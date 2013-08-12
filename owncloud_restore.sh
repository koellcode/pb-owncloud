#!/bin/bash
OWNCLOUDROOT="/var/www/owncloud/"
SRCD1="data"
SRCD2="config"
TGTD="/vagrant/backups"
PARAM=`pwd`/$1

DBDUMPD="db"
# read actual db passwd from config for sql dump
DBPASSWD=$(php -r 'include("'$OWNCLOUDROOT/$SRCD2'/config.php"); echo $CONFIG["dbpassword"];')
DBNAME=$(php -r 'include("'$OWNCLOUDROOT/$SRCD2'/config.php"); echo $CONFIG["dbname"];')
# sometimes the filename may differ
DBNAME_INPUT="owncloud"

echo restoring owncloud data folder.
cd $OWNCLOUDROOT && tar xvzf $PARAM $SRCD1
echo data folder restored.

echo extracting mysql dump
cd $TGTD && tar xvzf $PARAM $DBDUMPD/$DBNAME_INPUT.sql
echo restoring mysql dump
mysql -u owncloud -p$DBPASSWD $DBNAME < $TGTD/$DBDUMPD/$DBNAME_INPUT.sql
