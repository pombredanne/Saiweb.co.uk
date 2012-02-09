--- 
layout: post
title: Dbstat update
tags: 
- php
- mysql
- dbstat
---
<p>So I thought maybe it's time for an update.</p>
<p>The project is moving, albeit slowly, and I realy do not like the current PHP implementation, I want to move towards a C++ version, and I will do so as soon as I figure out how to do CLI "update/refresh" ...</p>
<p>i.e. See how W GET works with the progress bar and kbps all in text, I have NO idea how that works.</p>
<p>I am also looking at adding RRDTOOL support.</p>
<p>Anyway here's the current sample output:</p>
<p><code>[buzz@server01 .sysadmin]$ ./dbstat.php summary</code></p>
<p><code>----- mySQL dbStat v1.1 Summary Report-----</code></p>
<p><code>10 Databases checked</code></p>
<p><code>exampledb1: 13 tables (0 VIEWS 13 INNODB 0 MYISAM) 0.77MB DATA 0.64MB INDEX</code><br />
<code>exampledb2: 15 tables (0 VIEWS 14 INNODB 1 MYISAM) 0.22MB DATA 0.19MB INDEX</code><br />
<code>exampledb3: 62 tables (0 VIEWS 0 INNODB 62 MYISAM) 0.45MB DATA 0.5MB INDEX</code><br />
<code>exampledb4: 3 tables (0 VIEWS 0 INNODB 3 MYISAM) 0.02MB DATA 0.01MB INDEX</code><br />
<code>exampledb5: 4 tables (0 VIEWS 0 INNODB 4 MYISAM) 0.02MB DATA 0.01MB INDEX</code><br />
<code>exampledb6: 4 tables (0 VIEWS 0 INNODB 4 MYISAM) 39.81MB DATA 22.22MB INDEX</code><br />
<code>exampledb7: 3 tables (0 VIEWS 0 INNODB 3 MYISAM) 0.04MB DATA 0.01MB INDEX</code><br />
<code>exampledb9: 599 tables (8 VIEWS 1 INNODB 590 MYISAM) 8702.79MB DATA 4559.42MB INDEX</code><br />
<code>exampledb10: 22 tables (0 VIEWS 21 INNODB 1 MYISAM) 6.66MB DATA 2.26MB INDEX</code></p>
<p></p>

Detail:

<code>----- START mySQL dbStat v1.1 Detail Report: exampledb9 -----</code>
<code>exampledb9: 599 tables (8 VIEWS 1 INNODB 590 MYISAM) 8893.7MB DATA 4583.54MB INDEX</code>
<code>--- Table Index Ratio Report index:data (457 Tables) ---</code>
<code>exampledb9.table1: 315.0769:1</code>
<code>exampledb9.table2: 315.0769:1</code>
<code>exampledb9.table3: 157.5385:1</code>
<code>exampledb9.table4: 146.2857:1</code>
<code>exampledb9.table5: 128.0000:1</code>

... (I've truncated this very long list)

<code>--- Table Fragmentation Report (2 Tables) ---</code>
<code>exampledb9.atable: 0.6067</code>
<code>exampledb9.atable: 0.1285</code>
<code>--- Table Low Size Report (47 Tables) ---</code>
<code>exampledb9.atable: 0 bytes</code>
<code>exampledb9.atable: 0 bytes</code>
<code>exampledb9.atable: 0 bytes</code>
<code>exampledb9.atable: 0 bytes</code>
<code>exampledb9.atable: 0 bytes</code>

... (Truncated again)

<code>--- Table Detail Report (591 Tables) ---</code>
<code>SCHEMA.TABLENAME: ENGINE: ROWS: TOTAL SIZE (MB): DATA SIZE (MB): DATA PERCENTAGE OF TOTAL (%): INDEX SIZE (MB): INDEX PERCENTAGE OF TOTAL (%): LAST UPDATE TIME</code>
<code>exampledb9.a_table: MyISAM: 28906414: 3272.43531003: 3031.82567548: 92.6474: 204.63809450: 7.3526: 2008-05-22 11:59:42</code>

.. (truncated)

<code>----- END mySQL dbStat v1.1 Detail Report: exampledb9 -----</code>
