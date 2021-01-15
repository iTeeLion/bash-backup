#!/bin/bash

# Backup config
USER="MySqlUserHere"
PASSWORD="MySqlPasswordHere"
DIR="/home/path/to/backups/"

# Backup date config
DATE=$(date +%Y-%m-%d)
OUTPUT="$DIR$DATE"

# Creating directories
mkdir $DIR
mkdir $OUTPUT

echo "--- BACKUP STARTED: $OUTPUT ---"

items=`mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`.
for item in $items; do
    if [[ "$item" != "information_schema" ]] && [[ "$item" != _* ]] ; then
        echo "Backup item: $item"
        mysqldump --force --opt --user=$USER --password=$PASSWORD --databases $item > $OUTPUT/$DATE.$item.sql
        gzip $OUTPUT/$DATE.$item.sql
    fi
done

echo "--- BACKUP ENDED: $OUTPUT ---"
