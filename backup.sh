#!/bin/bash

# Define source and destination directories
Source='/home/vinks001/Music'
Destination='/home/vinks001/Backup'
LogFile='/home/vinks001/Backup/backup.log'
Timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
BackupDir="$Destination/backup_$Timestamp"

# Ensure the backup directory exists
mkdir -p "$BackupDir"

# Sync only new or modified files
rsync -av --update "$Source/" "$BackupDir/" >> "$LogFile" 2>&1

# Log the backup details
echo "Backup completed at $Timestamp" >> "$LogFile"
echo "----------------------------" >> "$LogFile"

# Delete backups older than 7 days
find "$Destination" -type d -name "backup_*" -mtime +7 -exec rm -rf {} \;

echo "Old backups older than 7 days deleted." >> "$LogFile"
echo "Backup process finished successfully!" 


