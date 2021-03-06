#!/bin/bash


CYCLE=$1
KEEPALIVE=$2

. /root/.profile

if [ $# -ne 2 ]; then 
	echo "Usage ./backupMongo cycle keepalive"
	exit 1
fi

echo "Project : ${PROJECT}"

if [ ! -d /data/backups/${CYCLE}/ ] ; then
	mkdir -p /data/backups/${CYCLE}/
fi

echo " /usr/bin/s3cmd get --recursive --skip-existing s3://${BUCKET_URL}/backups/${PROJECT}/ /data/backups/"
/usr/bin/s3cmd get --recursive --skip-existing s3://${BUCKET_URL}/backups/${PROJECT}/ /data/backups/

for file in `find /data/backups/${CYCLE}/ -type f -mtime +${KEEPALIVE}`
do
    echo "Deleting file : ${file}"
  rm $file
done

cd ${MONGO_BACKUP_DIR}

DATE=$(date +%Y%m%d-%H%M)
BACKUP_NAME=${PROJECT}_${DATE}

echo "${MONGO_HOME}/bin/mongodump ${MONGO_OPTS} -o ${MONGO_BACKUP_DIR}/${CYCLE}/${BACKUP_NAME}"
${MONGO_HOME}/bin/mongodump  ${MONGO_OPTS} --port 27017 -o ${MONGO_BACKUP_DIR}/${CYCLE}/${BACKUP_NAME}
if [ $? -eq 0 ]; then
	tar cvfz ${MONGO_BACKUP_DIR}/${CYCLE}/${BACKUP_NAME}.tar.gz ${MONGO_BACKUP_DIR}/${CYCLE}/${BACKUP_NAME}
	if [ $? -eq 0 ]; then
		rm -rf ${MONGO_BACKUP_DIR}/$CYCLE/${BACKUP_NAME}

		
		echo "Backup in progress : ${MONGO_BACKUP_DIR}/ s3://${BUCKET_URL}/backups/${PROJECT}/"
		/usr/bin/s3cmd sync  --delete-removed ${MONGO_BACKUP_DIR}/ s3://${BUCKET_URL}/backups/${PROJECT}/
		if [ $? -eq 0 ]; then
			echo "Checking uploaded file"
			echo "/usr/bin/s3cmd get --force s3://${BUCKET_URL}/backups/${PROJECT}/${CYCLE}/${BACKUP_NAME}.tar.gz /tmp/"

			/usr/bin/s3cmd get --force s3://${BUCKET_URL}/backups/${PROJECT}/${CYCLE}/${BACKUP_NAME}.tar.gz /tmp/
			if [ $? -eq 0 ]; then
				cd /tmp
				tar -tzf ${BACKUP_NAME}.tar.gz >/dev/null

				if [ $? -eq 0 ]; then 
					echo "Backup OK"
				else
					echo "Backup fail"
					exit 1
				fi

			else
				echo "Cannot get frenshly uploaded backup"
				exit 1
			fi	
		else
			echo "S3 sync fail"
			exit 1
		fi	
	else
		echo "Zip fail"
		exit 1
	fi	
else
	echo "Dump DB fail"
	exit 1
fi		

