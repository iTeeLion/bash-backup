#!/bin/bash

load_config () {
    SCRIPT_DIR="`dirname $0`"
    CFG_PATH="$SCRIPT_DIR/.config/backup_files_$1.cfg"
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
	if [ -z "$ITEMS_TO_BACKUP" ]; then
		echo "Backup folder: ${DIR_TO_BACKUP}"
		do_backup_item
	else
		if [[ "$(declare -p ITEMS_TO_BACKUP)" =~ "declare -a" ]]; then
			echo "Backup spicified items from folder: ${DIR_TO_BACKUP}"
		else
			echo "Backip all items from folder: ${DIR_TO_BACKUP}"
			cd $DIR_TO_BACKUP
			ITEMS_TO_BACKUP=$(find ./ -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
		fi

		for ITEM in ${ITEMS_TO_BACKUP[@]}; do
			do_backup_item $ITEM;
		done
	fi
}

do_backup_item () {
	BACKUP_DIR_PATH_ITEM="$BACKUP_DIR_PATH/$1"
	ITEM_TO_BACKUP_PATH="$DIR_TO_BACKUP/$1"
	if [[ -z "$1" ]]; then
		ZIP_NAME="backup"
	else
		echo "Backup item: $1"
	fi
	if [[ $ZIP_LVL > 0 ]]; then
		zip -r -u $EXCLUDE_ITEMS_ROW -$ZIP_LVL $BACKUP_DIR_PATH_ITEM$ZIP_NAME.zip $ITEM_TO_BACKUP_PATH
	else
		if [ -d "$ITEM_TO_BACKUP_PATH" ]; then
			cp -r $ITEM_TO_BACKUP_PATH $BACKUP_DIR_PATH_ITEM
		fi
		if [ -f "$ITEM_TO_BACKUP_PATH" ]; then
			cp $ITEM_TO_BACKUP_PATH $BACKUP_DIR_PATH_ITEM
		fi
	fi
}

echo "--- BACKUP STARTED: $BACKUP_DIR_PATH ---"
load_config $1
set_variables
prepare_folders
do_backup
echo "--- BACKUP ENDED: $BACKUP_DIR_PATH ---"
