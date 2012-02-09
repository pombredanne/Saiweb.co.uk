--- 
layout: post
title: "mysql moving /var/lib/mysql and error: 121"
tags: 
- mysql
- mount
- bind
---
The downside of a development server is ... it's for development.

It is  not always cost effective to have the exact same setup as you you have in your production environment ...

Especially if you have a multi server setup.

So I find myself today moving /var/lib/mysql ... being as the OS drive is very small, and pulling down a near 20GB database backup and then trying to rebuild the database on the same drive ... well as you can imagine caused a few problems *doh*

<code>
/etc/init.d/mysql stop
mv /var/lib/mysql /raid_5/
</code>

So surely you just symlink ... right?

<code>
ln -s /raid_5/mysql /var/lib/mysql
/etc/init.d/mysql start
</code>

Well then answer would be no ... upon importing the backup

<code>
mysql &lt; backup.sql
Can't create table './database/table.frm' (errno: 121)
</code>

A nice errorno: 121

<code>
/etc/init.d/mysql stop
rm -rf /var/lib/mysql
mkdir /var/lib/mysql
chown mysql:mysql /var/lib/mysql
mount --bind /raid_5/mysql /var/lib/mysql
/etc/init.d/mysql start
</code>

et voila ...

Data directory is relocated and the import working smoothly. Feel free to suggest any "cleaner" methods.

<strong>UPDATE</strong>: Please rememeber to add the 'mount' line into your rc.local otherwise when you reboot this mount will be gone!
