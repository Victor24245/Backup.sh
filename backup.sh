#!/bin/zsh



source='/home/vinks001/Music'
destination='/home/vinks001/Backup'
logfile='/home/vinks001/Backup/backup.log'

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
backup="$destination/backup_$timestamp"


mkdir -p "$backup"

if rsync -av --update "$source/" "$backup/" >> "$logfile" 2>&1; then
	echo "Backup completed at $timestamp" >> "$logfile"
else
	echo "Backup failed at $timestamp" >> "$logfile"

	exit 1
fi

echo "----------------" >> "$logfile"


#find and delete updates older than 7 days
if find "$destination" -type d -name "backup_*" -mtime +7 -exec rm -rf {} \; >> "$logfile" 2>$1; then
    echo "Backups older than 7 days deleted." >> "$logfile"
else
    echo "Failed to delete old backups." >> "$logfile"
fi

echo "Backup process complete." >> "$logfile"
