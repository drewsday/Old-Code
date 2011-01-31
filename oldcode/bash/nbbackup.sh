##########################################
#
# cdbackup.sh
#
# Tony Steidler-Dennison
# tony@lockergnome.com
# June 2-16, 2002
#
# Backs up user-specified files to CDR
#
# TO DO:
# auto-create list of files
#
##########################################

#!/bin/sh

# set and format the date variable and
# home directory variable

DATE=`/bin/date +%Y%m%d`
HOME="/home/morris"

# give me some feedback including the
# start time

echo "Starting CD Backup ..."
/bin/date

# use mysqldump to backup the current
# working databases

#mysqldump --tab=/var/lib/mysql/lg --opt -full > \
#/home/tony/backup/lg_db_$DATE.sql
#mysqldump --tab=/var/lib/mysql/4am --opt -full > \
#/home/tony/backup/4am_db_$DATE.sql
#mysqldump --tab=/var/lib/mysql/nuke --opt -full > \
#/home/tony/backup/nuke_db_$DATE.sql

# move the old backup list to a new
# name - necessary later for the diff

mv $HOME/backup/lists/*.list \
$HOME/backup/lists/prev_backup.list

# tar and gzip critical files using
# a list from /home/tony - this simplifies
# adding or removing files from the backup

tar -czf $HOME/backup/$DATE.tgz\
 $HOME/backup/ninjabunny/ \
> $HOME/backup/$DATE.list

# more feedback

#echo "Creating CD Image ..."
#/bin/date

# make an isofs image of the .tgz file
# and tgz list file just created

#mkisofs -r -f -o $HOME/backup/$DATE.iso \
#$HOME/backup/$DATE.tgz \
#$HOME/backup/lists/$DATE.list
# more feedback

#echo "Burning CD ..."
#/bin/date

# burn the newly-created iso image to disc

#/usr/bin/cdrecord -v -data speed=12 dev=0,0,0 \
#$HOME/backup/"$DATE".iso
# more feedback

echo "Mailing diff results ..."

# run diff, checking for differences between
# the old backup list and the new one

diff -aBH $HOME/backup/lists/prev_backup.list \
$HOME/backup/lists/$DATE.list \
| mail morris@localhost -s "$DATE Backup Results"

# more feedback

echo "Deleting temporary files ..."
/bin/date

# clean up the backup directory

#rm -f $HOME/backup/*.tgz
#rm -f $HOME/backup/*.iso
#rm -f $HOME/backup/*.sql

# final feedback

echo "Done."
/bin/date

exit


