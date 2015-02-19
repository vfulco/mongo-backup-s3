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

