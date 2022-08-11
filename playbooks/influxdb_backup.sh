#!/bin/bash
 
# Uses Dropbox-Uploader: https://github.com/andreafabrizi/Dropbox-Uploader/blob/master/dropbox_uploader.sh
 
db=$1
timestamp=$(date +%Y%m%d-%H%M%S)
backup_path="/tmp"
backup_folder="influxdb-backup-$db-$timestamp"
backup_zip="$backup_folder.tar.gz"
influxd backup -portable -database "$db" -host 127.0.0.1:8088 "$backup_path/$backup_folder"
tar -czf "$backup_path/$backup_zip" "$backup_path/$backup_folder"
/home/pi/dropbox_uploader.sh -f /home/pi/.dropbox_uploader upload "$backup_path/$backup_zip" "$backup_zip"
rm "$backup_path/$backup_zip"
 
# Add this to crontab: 0 0 * * * /home/pi/influxdb-backup.sh home