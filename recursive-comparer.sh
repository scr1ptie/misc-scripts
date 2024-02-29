#!/bin/bash

# Function to compare files recursively
compare_folders() {
    local folder1="$1"
    local folder2="$2"
    
    # Find all files in folder1 and compare them with their counterparts in folder2
    find "$folder1" -type f | while read -r file1; do
        file2="${folder2}${file1#$folder1}"
        if [ -f "$file2" ]; then
            echo "Differences between $file1 and $file2:"
            diff "$file1" "$file2"
            echo "----------------------------------------"
        else
            echo "File $file1 exists in $folder1 but not in $folder2"
            echo "----------------------------------------"
        fi
    done

    # Recursively call compare_folders for subdirectories
    find "$folder1" -mindepth 1 -type d | while read -r dir1; do
        dir2="${folder2}${dir1#$folder1}"
        compare_folders "$dir1" "$dir2"
    done
}

# Check if two directory paths are provided as arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory1> <directory2>"
    exit 1
fi

# Start comparing folders
compare_folders "$1" "$2"
