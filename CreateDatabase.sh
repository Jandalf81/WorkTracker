#!/bin/bash

# set variables
DATADIR="/srv/WorkTracker"
SRCDIR="/home/pi/WorkTracker"

# remove old file
rm $DATADIR/WorkTracker.sqlite

# create new file
sqlite3 $DATADIR/WorkTracker.sqlite < $SRCDIR/SQLite3/1.CreateDatabase.sql
sqlite3 $DATADIR/WorkTracker.sqlite < $SRCDIR/SQLite3/2.InsertData.sql

# set permissions
chmod 777 $DATADIR
chmod 777 $DATADIR/WorkTracker.sqlite

# list folder and file
ls $DATADIR/.. -l
ls $DATADIR -l