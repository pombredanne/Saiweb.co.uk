--- 
layout: post
title: mySQL bash backup script
tags: 
- mysql
- bash
- backup
- gzip
---
In on of those "oh ffs" moments I found myself writing a BASH script to quickly dump all database on a mySQL server.

[cc lang="bash" line="1"]
#!/bin/bash
MYSQL=`which mysql`;
MYSQLDUMP=`which mysqldump`;
GZIP=`which gzip`;
DEST="/path/to/dump/folder"

USER="root";
PWD="XXXXXX";

DBS=(`$MYSQL  -u $USER -p$PWD  -Bse 'show databases'`);

for db in ${DBS[@]};
do
        `$MYSQLDUMP --default-character-set=utf8 --set-charset -u $USER -p$PWD $db | $GZIP -9 > $DEST/$db.sql.gz`
        echo "$db - DONE";
done;
[/cc]

This script gets a list of all databases, dumps them out with UTF8 encoding, and gzip compresses the SQL file into the given "DEST" folder.

If you want to skip over certain databases i.e. "mysql"

Change this line:

[cc lang="bash" line="10"]
DBS=(`$MYSQL  -u $USER -p$PWD  -Bse 'show databases'`);
[/cc]

To:
[cc lang="bash" line="10"]
DBS=(`$MYSQL  -u $USER -p$PWD  -Bse 'show databases' | grep -v "database_to_exclude"`);
[/cc]

Or for multiple exclusions

[cc lang="bash" line="10"]
DBS=(`$MYSQL  -u $USER -p$PWD  -Bse 'show databases' | grep -v "database_to_exclude" | grep -v "another_database_to_exclude" | grep -v "etc"`);
[/cc]


I may re-write this in Python, if I get time.

