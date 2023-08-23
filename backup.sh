#!/bin/bash

# Set source directory
SOURCE_DIR="/path/to/source"

# Set SFTP connection details
SFTP_USER="your_username"
SFTP_HOST="machine_b_ip"
SFTP_PORT="your_sftp_port"
SSH_PRIVATE_KEY="/path/to/ssh/private/key"

# Set remote destination directory on Machine B
DEST_DIR="/path/to/remote/destination"

# Create a folder named with the current date
BACKUP_FOLDER="$(date +\%Y\%m\%d)"
REMOTE_BACKUP_DIR="$DEST_DIR/$BACKUP_FOLDER"

# SFTP command
sftp_command="sftp -i $SSH_PRIVATE_KEY -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST"

# Create the remote backup folder
$sftp_command <<EOF
mkdir "$REMOTE_BACKUP_DIR"
quit
EOF

# Transfer all files from source to remote backup folder
for file in "$SOURCE_DIR"/*; do
    if [[ -f "$file" ]]; then
        $sftp_command <<EOF
        put "$file" "$REMOTE_BACKUP_DIR/"
EOF
    fi
done
