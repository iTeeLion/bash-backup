#!/bin/bash

# Backup config
DIR="/home/path/to/backups/"
items=(
"apache2"
"php"
"bash.bashrc"
"hostname"
"hosts"
)
ZIPLVL=9

# Backup date config
DATE=$(date +%Y-%m-%d)
OUTPUT="$DIR$DATE"

# Creating directories
mkdir $DIR
mkdir $OUTPUT

echo "--- BACKUP STARTED: $OUTPUT ---"

for item in ${items[@]}; do
    echo "Backup item: $item"

    itempath="/etc/$item"
    # set type of backup zip/files
    if true; then
      zip -r -$ZIPLVL $OUTPUT/etc.zip $itempath
    else
      if [ -d "$itempath" ]; then
          cp -r $itempath $OUTPUT/$item
      fi
      if [ -f "$itempath" ]; then
          cp /etc/$itempath $OUTPUT/$item
      fi
    fi
done

echo "--- BACKUP ENDED: $OUTPUT ---"
