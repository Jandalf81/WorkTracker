#!/bin/bash

rm WorkTracker.sqlite

sqlite3 WorkTracker.sqlite < ./SQLite3/CreateDatabase.sql

sqlite3 WorkTracker.sqlite < ./SQLite3/InsertTestdata.sql

chmod 777 WorkTracker.sqlite