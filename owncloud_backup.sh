#!/bin/bash
OWNCLOUDROOT="/var/www/owncloud/"
SRCD1="data"
SRCD2="config"
TGTD="/vagrant/backups/"
OF=owncloud-backup-$(date +%Y%m%d).tar

DBDUMPD="db"
# read actual db passwd from config for sql dump
DBPASSWD=$(php -r 'include("'$OWNCLOUDROOT/$SRCD2'/config.php"); echo $CONFIG["dbpassword"];')
DBNAME=$(php -r 'include("'$OWNCLOUDROOT/$SRCD2'/config.php"); echo $CONFIG["dbname"];')

mkdir -p $TGTD

echo backup ownclouds data and config folder
cd $OWNCLOUDROOT && tar -cf $TGTD$OF $SRCD1 $SRCD2

mkdir -p $DBDUMPD

echo backup mysql database
mysqldump -u owncloud -p$DBPASSWD -l $DBNAME > $DBDUMPD/$DBNAME.sql

echo adding dbdump to tar
tar -rf $TGTD$OF $DBDUMPD/$DBNAME.sql

echo compressing backup
gzip $TGTD$OF

echo cleanup dbdump
rm -rf $DBDUMPD

echo done
