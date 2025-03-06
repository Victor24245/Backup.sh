#!/bin/bash

echo "Input D|d for Directory and F|f for File"
read -p "to specify what you want to backup: " user_input

Backup_location="/home/vinks001/Desktop/Backup__1"
mkdir -p "$Backup_location/logfile"
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
logs=$(date +"%Y-%m-%d_%H-%M-%S")
log_dir="$Backup_location/logfile/$logs"
mkdir -p "$log_dir"

case $user_input in
    F|f)
        while true; do
            read -p "Enter the file name: " file
            if [[ -n "$file" ]]; then
                break
            fi
            echo "File name cannot be empty. Please try again."
        done

        # Search for the file
        find /home -type f -iname "**$file**" > options.txt 2>/dev/null

        if [ ! -s options.txt ]; then
            echo "File not found!"
	    exit 1
        fi

        # Display the search results
        list=()
        index=1
        while IFS= read -r item; do
            list+=("$item")
            echo "$index) $item"
            ((index++))
        done < options.txt

        # Telling the user to pick a file for backup
        read -p "Enter the number of your option: " inp
        if [[ "$inp" =~ ^[0-9]+$ ]] && [ "$inp" -lt "${#list[@]}" ]; then
            selected_path="${list[$inp]}"
            echo -e "You selected: $selected_path"

            # Zip the file
	    zip -v "$Backup_location/$timestamp/backup.zip" "$selected_path" | tee >> "$log_dir/log.txt" 
            echo "========================================"
            echo "File saved to $Backup_location/backup.zip"
        else
            echo "Invalid selection."
            exit 1
        fi
        ;;

    D|d)
        read -p "Enter the directory path: " directory
	find /home -type d -iname "**$directory**" > directory.txt 2>/dev/null
        if [ ! -s directory.txt ]; then
		echo "Directory not found"
		exit 1
	fi
	list=()
	index=1
	while IFS= read -r items; do
		list+=("$items")
		echo "$index)$items"
		((index++))
       	
	done < directory.txt
	#echo "Directory found. Backing up..."
        #zip -r "$Backup_location/backup.zip" "/$directory" | tee "$log_dir/log.txt"
        #echo "Backup saved to $Backup_location/backup.zip"
        ;;

    *)
        echo "Invalid input. Please enter D/d for directory or F/f for file."
        exit 1
        ;;
esac

