--- 
layout: post
title: mysql csv export scripting using TCL and expect
date: 2010-07-05 15:06:15 +01:00
tags: 
- mysql
- expect
- tcl
- csv
wordpress_url: linux/mysql-csv-export-scripting-using-tcl-and-expect
---
I've no idea to this day why my bash script would not work with a CSV export from mysql by simply using mysql -e "SQL COMMAND HERE".

So I had to come up with a workaround quickly.

This lead to using <a href="http://linux.die.net/man/1/expect">expect</a>, scripting in this method can be used for numerous purposes, I am currently in the process of writing a few test scripts using tcl and this package for pop,imap,smtp testing.

[cc lang="tcl"]
#!/usr/bin/expect -f
set DB "<database>"
set USER "<user>"
set PASS "<password>"

spawn mysql -u $USER -p $DB
match_max 100000
expect -exact "assword: "
send -- "$PASS\r"

set SQL "SELECT * INTO OUTFILE '/tmp/csvfile.csv' FROM table";

expect -exact "mysql> "
send -- "$SQL;\r"
expect -exact "mysql> "
sent -- "exit;/r"
[/cc]

Pretty simple realy once you have the hang of it, you tell it what to expect and what to reply with, there are more advanced methods going on from here, including conditional sends based on response.

I'll be covering those soon.
