#!/bin/bash

load_config () {
    SCRIPT_DIR="`dirname $0`"
    CFG_PATH="$SCRIPT_DIR/.config/yandex_clear_trash.cfg"
    if [ -e $CFG_PATH ]
    then
        tr -d '\r' < $CFG_PATH > $CFG_PATH.tmp
        rm $CFG_PATH
        mv $CFG_PATH.tmp $CFG_PATH
        chmod 0770 $CFG_PATH
        sleep 1
        source $CFG_PATH
    else
        echo "No config found! ${CFG_PATH}"
        exit 1
    fi
}

do_clear () {
    /usr/bin/curl -s -H "Authorization: $API_KEY" -X "DELETE" https://cloud-api.yandex.net/v1/disk/trash/resources/?path=
}

echo "--- BACKUP STARTED: $BACKUP_DIR_PATH ---"
load_config
do_clear
echo "--- BACKUP ENDED: $BACKUP_DIR_PATH ---"
