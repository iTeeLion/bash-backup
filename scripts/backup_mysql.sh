#!/bin/bash

load_config () {
    CFG_PATH=".config/backup_mysql.cfg"
    if [ -e $CFG_PATH ]
    then
        tr -d '\r' < $CFG_PATH > $CFG_PATH.tmp
        rm $CFG_PATH
        mv $CFG_PATH.tmp $CFG_PATH
        chmod 0770 $CFG_PATH
        source $CFG_PATH
    else
        echo "No config found!"
        exit 1
    fi
}

set_variables () {
    TODAY=$(date +%Y-%m-%d)
    BACKUP_DIR_PATH="${BACKUPS_DIR_PATH}/${TODAY}"
}

prepare_folders () {
    mkdir -p $BACKUP_DIR_PATH
    find $BACKUPS_DIR_PATH -mtime +5 -delete
}

do_backup () {
    ITEMS_TO_BACKUP=`mysql --user=$MYSQL_USER --password=$MYSQL_PASS -e "SHOW DATABASES;" | tr -d "| " | grep -v Database` 
    for ITEM in $ITEMS_TO_BACKUP; do
        if [[ "$ITEM" != "mysql" ]] && [[ "$ITEM" != "information_schema" ]] && [[ "$ITEM" != "performance_schema" ]] && [[ "$ITEM" != _* ]] ; then
            echo "Backup item: $ITEM"
            mysqldump --force --opt --user=$MYSQL_USER --password=$MYSQL_PASS --databases $ITEM > $BACKUP_DIR_PATH/$ITEM.sql
            gzip -f $BACKUP_DIR_PATH/$ITEM.sql
        fi
    done
}

echo "--- BACKUP STARTED: $OUTPUT ---"
load_config
set_variables
prepare_folders
do_backup
echo "--- BACKUP ENDED: $OUTPUT ---"
