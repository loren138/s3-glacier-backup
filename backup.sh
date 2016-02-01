#!/bin/bash
set -e

s3bucket="loren-backup"
backupTo="$HOME/Backup" # This folder must already exist
backupFolder=$(date '+%d%b%Y') # Only the contents of this folder will be set to S3, you may add your own files
                               # Files will be deleted after being uploaded
backupPath="$backupTo/$backupFolder"
backupPassword="test" # You must specify a password

# Folders to backup (name in backup folder path)
declare -a folders=("documents $HOME/Documents" "downloads $HOME/Downloads" "desktop $HOME/Desktop");


## Script Starts here
# http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
# Use > 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use > 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to > 0 the /etc/hosts part is not recognized ( may be a bug )
runBackup=true
while [[ $# > 0 ]]
do
key="$1"

case $key in
    --noBackup)
    runBackup=false
    ;;
    #-s|--searchpath)
    #SEARCHPATH="$2"
    #shift # past argument
    #;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

echo "Creating Backup Folder $backupFolder"
cd $backupTo
mkdir -p $backupFolder

if [ "$runBackup" = true ]; then
   echo "Creating 7-Zip Archives"
	for i in "${folders[@]}"
	do
		7za a -v512m -p${backupPassword} $backupPath/$i
	done
fi


echo "Moving Files"
cd ${backupFolder}
if [ `ls ${backupPath}` ]
then
	for f in *
	do
		s3cmd sync ${f} s3://${s3bucket}/${backupFolder}
		rm ${f}
	done
else
  echo "No files to upload"
fi