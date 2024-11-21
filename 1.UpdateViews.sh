#!/bin/bash

# set variables
DATADIR="/srv/WorkTracker"
SRCDIR="/home/pi/WorkTracker"

# update views
sqlite3 $DATADIR/WorkTracker.sqlite < $SRCDIR/SQLite3/3.UpdateViews.sql