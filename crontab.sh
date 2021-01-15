#!/bin/bash

# Backup configs
DIR="/home/path/to/backups/"
items=("root" "user1" "user2")

# Date configs
DATE=$(date +%Y-%m-%d)
OUTPUT="$DIR$DATE"

mkdir $DIR
mkdir $OUTPUT

echo "--- BACKUP STARTED: $OUTPUT ---"

for item in ${items[@]}; do
    echo "Backup item: $item"
    crontab -u $item -l > $OUTPUT/$DATE_$item.txt
done

echo "--- BACKUP ENDED: $OUTPUT ---"
