#!/bin/bash

rm db.sqlite

sqlite3 db.sqlite < ./SQLite3/CreateDatabase.sql

sqlite3 db.sqlite < ./SQLite3/InsertTestdata.sql