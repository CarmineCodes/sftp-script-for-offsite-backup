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

### Setting up the script

In a directory of your choice (mine is in the /home/your user directory) make a file and name is 

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


From there, copy the below script into it and fill in your information to match

    until finished

End with an example of getting some data out of the system or using it
for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Sample Tests

Explain what these tests test and why

    Give an example

### Style test

Checks if the best practices and the right coding style has been used.

    Give an example

## Deployment

Add additional notes to deploy this on a live system

## Built With

  - [Contributor Covenant](https://www.contributor-covenant.org/) - Used
    for the Code of Conduct
  - [Creative Commons](https://creativecommons.org/) - Used to choose
    the license

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code
of conduct, and the process for submitting pull requests to us.

## Versioning

We use [Semantic Versioning](http://semver.org/) for versioning. For the versions
available, see the [tags on this
repository](https://github.com/PurpleBooth/a-good-readme-template/tags).

## Authors

  - **Billie Thompson** - *Provided README Template* -
    [PurpleBooth](https://github.com/PurpleBooth)

See also the list of
[contributors](https://github.com/PurpleBooth/a-good-readme-template/contributors)
who participated in this project.

## License

This project is licensed under the [CC0 1.0 Universal](LICENSE.md)
Creative Commons License - see the [LICENSE.md](LICENSE.md) file for
details

## Acknowledgments

  - Hat tip to anyone whose code is used
  - Inspiration
  - etc
