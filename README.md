# S3 Glacier Backup

Setup:
* InstallS3 Tools - http://s3tools.org/download (Please install according to it's instructions.)
* Install p7zip - http://sourceforge.net/projects/p7zip/ (brew install p7zip or available via apt on many systems)
* Run `s3cmd --configure` and enter your AWS Credentials
* Create the S3 bucket you wish to backup to.  If you want backups to go to glacier, set a lifecycle rule in the bucket
  to send everything to glacier after one day. (https://aws.amazon.com/blogs/aws/archive-s3-to-glacier/)
* Configure the variables in the script (backup.sh)
* Set backup.sh to be executable `chmod u+x backup.sh`

To run a backup, run `./backup.sh`.  If uploads fail or if you are putting files into the folder some other way,
you can run `./backup.sh --noBackup` to just perform uploads.

If the script fails

Note: This tool does NOT backup usernames.

(From the p7zip readme)
CAUTION :
---------

- FIRST : DO NOT USE the 7-zip format for backup purpose on Linux/Unix because :
  - 7-zip does not store the owner/group of the file

  On Linux/Unix, in order to backup directories you must use tar !
  to backup a directory  : tar cf - directory | 7za a -si directory.tar.7z
  to restore your backup : 7za x -so directory.tar.7z | tar xf -

- if you want to send files and directories (not the owner of file)
  to others Unix/MacOS/Windows users, you can use the 7-zip format.

  example : 7za a directory.7z  directory

  do not use "-r" because this flag does not do what you think
  do not use directory/* because of ".*" files
   (example : "directory/*" does not match "directory/.profile")

