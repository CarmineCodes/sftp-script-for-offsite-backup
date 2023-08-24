# USING SFTP FOR OFFSITE BACKUPS

Having backups is important but redundant backups are even more important in case of a horrible situation. By using ssh-keys, sftp and cron jobs with this script we can automate moving out backup files to a vps to have additional backups in case we lose a local one by chance.

## Getting Started

To get started we will need a few things:

1: A VPS or other accessible share that we can sftp to

2: Local backups on the network

3: Patience

4: Ssh-keys in place

Beyond this you will just need to know the following:

1: The source directories with the backup files

2: The destination directory to send the files to

3: What port is being used for ssh

4: Where your ssh key is stored

### Generating SSH Key Pair

We need to generate a ssh key pair so we can connect the two machines for ssh access for the sftp script to work simpler. This can be done with the below commands.

    ssh-keygen -t rsa

This generates the keys, you can use a passphrase if you want to but is not needed unless you have a public facing machine. Take note of the directory that the keys are being stored, it’ll be needed for later on.

Now we need to send the key to the remote machine and this will be done with the below command:

    ssh-copy-id user@machine_b_ip

Put a root user for user and the public ip for machine_b-ip

It will ask if the ssh signature is correct and then it will pass they key and you can now ssh into the second machine from machine a without a password. You can test it with the below command.

    ssh user@machine_b_ip
    
### Setting up the script

In a directory of your choice (mine is in the /home/your user directory) make a file and name it backup.sh

when using the below script, make sure to fill in your information for SOURCE_DIR, SFTP_USER, SFTP_HOST, SFTP_PORT, SSH_PRIVATE_KEY, DEST_DIR, 

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


Now that we have our script we need to make it executable

    sudo chmod +x /backup.sh

Now the script is executable, and we can run it to test to see if it works properly. If your source directory has a lot of data in it, it will take a while to finish moving the data so be prepared, maybe start with a simple test file to ensure your script is working how you want before you try to copy all your backups.

Now we are ready to run our script with:

        sudo ./backup.sh
        
### Writing the Cron Job

To take our script and make it run automatically we need to use a cron job. This will make it so the script will run on a schedule we set and move the files to our backup location without us having to.

We need to open the crontab with the below command so we can modify it to run our new script

    crontab -e

Then select option one to use nano

Using the following base format, it can be modified based on when you want the sftp job to run and then have the patch to your backup.sh script in it.

    0 0 * * * /path/to/backup.sh

Now our backup script is written and with the use of cron jobs will automatically move the backup files over to our new share to keep them safe.

