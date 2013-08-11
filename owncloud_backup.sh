#!/bin/bash          
SRCD1="/var/www/owncloud/data"
SRCD2="/var/www/owncloud/config"
TGTD="/vagrant/backups/"
OF=owncloud-backup-$(date +%Y%m%d).tar

DBDUMPD="/vagrant/backups/db"
# read actual db passwd from config for sql dump
DBPASSWD=`sudo php -r 'include("/var/www/owncloud/config/config.php"); echo $CONFIG["dbpassword"];'`

mkdir -p $TGTD

echo backup ownclouds data and config folder
tar -Pcf $TGTD$OF $SRCD1 $SRCD2

mkdir -p $DBDUMPD

echo backup mysql database
mysqldump -u owncloud -p$DBPASSWD -l > $DBDUMPD/owncloud_db.sql

echo adding dbdump to tar
tar -Prf $TGTD$OF $DBDUMPD/owncloud_db.sql

echo compressing backup
gzip $TGTD$OF

echo cleanup dbdump
rm -rf $DBDUMPD

echo done
