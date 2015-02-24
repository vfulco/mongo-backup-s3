# mongo-backup-s3

mongo-backup-s3 is a very small project aimed for help you to backup and restore your MongoDB database. 
Both scripts must be placed on the host (the same host where MongoDB is installed) and must be run with sufficient permission to execute some MongoDB commands and access to /data.


These scripts have been tested on Linux Ubuntu 14.04 and : 

| Tool          | Version       |
|---------------|---------------|
| MongoDB       | 2.6.5         |
| s3cmd         | 1.1.0-beta3   |

## Prerequisite
### S3cmd
#### Setup
* Please refer to http://s3tools.org/repositories

#### Configure
* Create a user in your AWS console with S3 access,
* Configure your host with S3 access key and secret key (this action create a .s3cfg file in your home) :
```bash
s3cmd --configure
```
* Check that's all it's okay (this command list all you available bucket : 
```bash
s3cmd ls
```

### MongoDB

* Please refer to http://www.mongodb.org/
* Add MongoDB to your PATH


## Configuration

In /root/.profile file, put the following information related to your environment :

| Param               | Description                                             |
|---------------------|---------------------------------------------------------|
| PROJECT             | Your project name. Used in tree view in S3              |
| BUCKET_URL          | Your S3 bucket name                                     |
| DB_USER             | The MongoDB user                                        |
| DB_NAME             | The MongoDB database name                               |
| DB_PWD              | Your password  for your project                         |
| MONGO_OPTS          | Some additionnal parameters for MongoDB connection      |
| MONGO\_BACKUP\_DIR  | Root directory where backup are stored in local host    |
| MONGO_HOME          | Directory where mongo is installed                      |
| DEFAULT\_BACKUP\_DIR| Default directory where restore script look for backup  |

*Exemple :*
```bash
PROJECT=myProjectName
BUCKET_URL=my.backups.bucket
DB_USER=myProjectDatabaseUser
DB_NAME=myProjectDatabaseName
DB_PWD=myProjectDatabasePasswd
MONGO_OPTS="-u myMongoAdmin -p mypasswd --authenticationDatabase myAuthDB"
MONGO_BACKUP_DIR=/data/backups
MONGO_HOME=/opt/mongo
DEFAULT_BACKUP_DIR=daily
```

## How to use 
### backupMongo
This script will backup your data to S3 Bucket describe in your configuration.

* 2 parameters for this script :

| Parameter   | Position  | Description                                                                        |
|-------------|-----------|------------------------------------------------------------------------------------|
| cycle       |   1       | This is a subdirectory where backup is push (see example for better comprehention) |
| keepalive   |   2       | This parameter indicate how many day you will conserve this backup                 |

* Usage :
```bash
backupMongo cycle keepalive
```

*Example :*
This command make a backup and upload it on S3 (`${BUCKET_URL}/backup/${PROJECT}/daily/${PROJECT}_DATE.tar.gz`) and conserve it during 7 days

```bash
./backupMongo daily 7
```

This command make a backup and upload it on S3 (`${BUCKET_URL}/backup/${PROJECT}/monthly/${PROJECT}_DATE.tar.gz`) and conserve it during 30 days

```bash
./backupMongo monthly 30
```

*Tips*
You can easily cron your backup like that :
```bash
# Daily Backup conserving last 7 daily backup
0 1 * * * /script/backupMongo daily 7  >> /var/log/mongo-backup.log 2>&1

# Weekly Backup conserving last 4-5 weekly backup
0 0 * * 0 /script/backupMongo weekly 31  >> /var/log/mongo-backup.log 2>&1

# Monthly Backup conserving last 12 monthly backup
0 2 1 * * /script/backupMongo monthly 365  >> /var/log/mongo-backup.log 2>&1

# Yearly Backup conserving last 10 yearly backup
0 3 1 1 * /script/backupMongo yearly 3600  >> /var/log/mongo-backup.log 2>&1
```

### restoreMongo
This script will help you to restore some data to your database.

* Choose which backup will be restore from `DEFAULT_BACKUP_DIR` backup directory
* Choose if you want to conserve the older database
* Choose the schema for your restoration
* Choose the future database name
* Before each choice, you can see a proposal base on your configuration and your last backup

```bash
./restoreMongo
```
