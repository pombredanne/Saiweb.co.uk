--- 
layout: post
title: Can't change to run as user 'mysql'. Please check that the user exists!
tags: 
- mysql
date: "2008-03-17"
---
So you've recently made a change to your mysql installation and see the following in

 /var/lib/mysql/server.err

 <code>080317 14:08:50 mysqld started
080317 14:08:50 [ERROR] Fatal error: Can't change to run as user 'mysql' ; Please check that the user exists!</code><code>080317 14:08:50 [ERROR] Aborting

080317 14:08:50 [Note] /usr/sbin/mysqld: Shutdown complete

080317 14:08:50 mysqld ended

</code> This is a problem that many a time spent on google has not found the result, so I am writing here what exactly to do in this situation ...

 First off

<code> cd /var/lib/mysql</code>

Now run <code>ls -la</code>

 No doubt you will see something similar to this:

<code>drwx--x--x   2 27 mysql     4096 Mar 17 14:05 mysql</code>

Notice the "27 mysql", the user no longer existsing in /etc/passwd.

This is fairly simple to fix.

<code>adduser mysql</code>
<code>chown mysql:mysql -R /var/lib/mysql</code>

Now start up Mysql i.e. "service start mysql" and everyhing _should_ be fine. 
