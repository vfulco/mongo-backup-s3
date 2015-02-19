# mongo-backup-s3

These script have been tested on Linux Ubuntu 14.04 and : 

| Tool          | Version       |
|---------------|---------------|
| MongoDB       | 2.6.5         |
| s3cmd         | 1.1.0-beta3   |

## Prerequisite
### S3cmd
#### Setup
* Import S3tools signing key: 
```bash
wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -
```  
* Add the repo to sources.list: 
```bash
sudo wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
```
* Refresh package cache and install the newest s3cmd: 
```bash
sudo apt-get update && sudo apt-get install s3cmd
```
*Source :* http://s3tools.org/repositories

#### Configure
* Create one user in your aws console with S3 access :
* Configure your host with S3 access key and secret key (this action create a .s3cfg file in your home) :
```bash
s3cmd --configure
```
* Check that's all it's okay (this command list all you available bucket : 
```bash
s3cmd ls
```

### MongoDB

* See : http://www.mongodb.org/
* Add mongo to your PATH


## Configuration

In /root/.profile file, put folowing informations related to your environment :

| Param               | Description                                             |
|---------------------|---------------------------------------------------------|
| PROJECT             | Your project name. Use in tree view in S3               |
| BUCKET_URL          | Your bucket S3 url                                      |
| DB_USER             | Your user in mongo for your project                     |
| DB_NAME             | Your database name for your project                     |
| DB_PWD              | Your password  for your project                         |
| RIGHT               | Some additionnal parameters during database connection  |
| MONGO\_BACKUP\_DIR  | Directory where backup are store in local host          |
| MONGO_HOME          | Directory where mongo is install                        |

*Exemple :*
```bash
PROJECT=myProjectName
BUCKET_URL=my.backups.bucket
DB_USER=myProjectDatabaseUser
DB_NAME=myProjectDatabaseName
DB_PWD=myProjectDatabasePasswd
RIGHT="-u myMongoAdmin -p mypasswd --authenticationDatabase myAuthDB"
MONGO_BACKUP_DIR=/data/backups
```

## How to use 
### backupMongo
* 2 parameters for this script : 
| Parameter   | Position  | Description                                                         |
|-------------------------|---------------------------------------------------------------------|
| cycle       |   1       | This is a subdirectory where backup is push                         |
| keepalive   |   2       | This parameter indicate how many day you will conserve this backup  |
* Usage :
```bash
backupMongo cycle keepalive
```

*Example :*
This command make a backup, push it in ${BUCKET\_URL}/backup/${PROJECT}/daily/${PROJECT}\_*DATE*.tar.gz and conserve it during 7 days
```bash
./backupMongo daily 7
```

This command make a backup, push it in ${BUCKET\_URL}/backup/${PROJECT}/monthly/${PROJECT}\_*DATE*.tar.gz and conserve it during 30 days
```bash
./backupMongo monthly 30
```

*Tips*
You can easly cron your backup like that :
```bash
# Daily Backup conserving last 7 daily backup
0 1 * * * /script/backupMongo daily 7  >> /var/log/mongo-backup.log 2>&1

# Weekly Backup conserving last 4-7 weekly backup
0 0 * * 0 /script/backupMongo weekly 31  >> /var/log/mongo-backup.log 2>&1

# Monthly Backup conserving last 12 monthly backup
0 2 1 * * /script/backupMongo monthly 365  >> /var/log/mongo-backup.log 2>&1

# Yearly Backup conserving last 10 yearly backup
0 3 1 1 * /script/backupMongo yearly 3600  >> /var/log/mongo-backup.log 2>&1
```
