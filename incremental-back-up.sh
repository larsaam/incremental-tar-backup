#!/bin/bash

DATE=`date +%Y%m%d`

#I do this check just to see if there is an incremental
if [ -f /path/to/workspace/DIR.level0.snar ]; then
  # copy the level 0 of incremental, if not
  #to retrieve a state from the DIR you would have to
  #extract incremental by incremental until the time you want
  #in this way, I only extract the full and the one I want to restore
  cp /path/to/workspace/DIR.level0.snar /path/to/workspace/DIR.snar
  
  #For convenience I move to the directory that contains DIR
  # && do tar with incremental and save it with differential name
  # && move it to the collection/storage directory
  cd /path/to/dir && tar --listed-incremental /path/to/workspace/DIR.snar -czpf /path/to/workspace/DIR-$DATE-incremental.tar.gz DIR && mv /path/to /workspace/DIR-$DATE-incremental.tar.gz /backup
fi

# to recover an incremental backup you have to throw:
# tar -xzpf FILE_BACKUP_FULL.tar.gz
# tar -xzpf INCREMENTAL_FILE.tar.gz
#
# ex:
# tar -xzpf PAIGH-[DATE_YEAR]-full.tar.gz
# tar -xzpf PAIGH-[FECHA_RESTORE_DESEADA_ACA]-incremental.tar.gz
