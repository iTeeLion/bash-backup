#!/bin/bash

load_config () {
    CFG_PATH=".config/backup_cron.cfg"
    if [ -e $CFG_PATH ]
    then
        tr -d '\r' < $CFG_PATH > $CFG_PATH.tmp
        rm $CFG_PATH
        mv $CFG_PATH.tmp $CFG_PATH
        chmod 0770 $CFG_PATH
        source $CFG_PATH
    else
        echo "No config found! ${CFG_PATH}"
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
    for ITEM in ${ITEMS_TO_BACKUP[@]}; do
        echo "Backup item: $ITEM"
        crontab -u $ITEM -l > $BACKUP_DIR_PATH/$ITEM.txt
    done
}

echo "--- BACKUP STARTED: $BACKUP_DIR_PATH ---"
load_config
set_variables
prepare_folders
do_backup
echo "--- BACKUP ENDED: $BACKUP_DIR_PATH ---"
