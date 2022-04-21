#!/bin/bash

DATE=`date +%Y%m%d`

#Replace DIR references with the directory you want to backup
#This script is the one for full back up and initialization of DIR.snar
#Should only run every N days. Daily we do an incremental
# with the other script.
#DIR.snar is the snapshot file we are going to use with tar

#Step 1
# We delete all the snar that are in the directory that we use from 'workspace'
#I prefer to do this in a local directory and then pass things
# to backup directory for collection/long-term storage
#Use the path that suits you best
rm /path/to/workspace/*snar

#Step 2
#For simplicity I move to the parent directory I want to backup
# && make the tar.gz with listed-incremental to a DIR.snar, the name
# of the tar file I do it with the date
# && move the file to the collection/storage directory
cd /path/to/dir && tar --listed-incremental /opt/backups/DIR.snar -czpf /path/to/workspace/DIR-$DATE-full.tar.gz DIR && mv /path/to/workspace /DIR-$DATE-full.tar.gz /backup

#Step 3
#With --listed-incremental the file DIR.snar is created,
# make a copy forever after using incremental level 0
# (see in the incremental script, the copy is done backwards)
cp /path/to/workspace/DIR.snar /opt/backups/DIR.level0.snar
