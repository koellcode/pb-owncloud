#!/bin/bash
OWNCLOUDROOT="/var/www/owncloud/"
SRCD1="data"
SRCD2="config"
TGTD="/vagrant/backups/"
OF=owncloud-backup-$(date +%Y%m%d).tar

DBDUMPD="db"
# read actual db passwd from config for sql dump
DBPASSWD=`sudo php -r 'include("/var/www/owncloud/config/config.php"); echo $CONFIG["dbpassword"];'`

mkdir -p $TGTD

echo backup ownclouds data and config folder
cd $OWNCLOUDROOT && tar -cf $TGTD$OF $SRCD1 $SRCD2

mkdir -p $DBDUMPD

echo backup mysql database
mysqldump -u owncloud -p$DBPASSWD -l > $DBDUMPD/owncloud_db.sql

echo adding dbdump to tar
tar -rf $TGTD$OF $DBDUMPD/owncloud_db.sql

echo compressing backup
gzip $TGTD$OF

echo cleanup dbdump
rm -rf $DBDUMPD

echo done
