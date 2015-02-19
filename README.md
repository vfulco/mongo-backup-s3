# mongo-backup-s3

These script have been tested on Linux Ubuntu 14.04 and : 

| Tool          | Version       |
|---------------|---------------|
| MongoDB       | 2.6.5         |
| s3cmd         | 1.1.0-beta3   |

## Prerequisite
### S3cmd

* Import S3tools signing key: 
```
wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -
```  
* Add the repo to sources.list: 
```
sudo wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
```
* Refresh package cache and install the newest s3cmd: 
```
sudo apt-get update && sudo apt-get install s3cmd
```
*Source :* http://s3tools.org/repositories

### MongoDB

See : http://www.mongodb.org/

## Configuration

In /root/.profile file, put folowing informations related to your environment :

| Param         | Description                                             |
|---------------|---------------------------------------------------------|
| PROJECT       | Your project name. Use in tree view in S3               |
| BUCKET_URL    | Your bucket S3 url                                      |
| DB_USER       | Your user in mongo for your project                     |
| DB_NAME       | Your database name for your project                     |
| DB_PWD        | Your password  for your project                         |
| RIGHT         | Some additionnal parameters during database connection  |

*Exemple :*
```bash
PROJECT=myProjectName
BUCKET_URL=my.backups.bucket
DB_USER=myProjectDatabaseUser
DB_NAME=myProjectDatabaseName
DB_PWD=myProjectDatabasePasswd
RIGHT="-u myMongoAdmin -p mypasswd --authenticationDatabase myAuthDB"
```

