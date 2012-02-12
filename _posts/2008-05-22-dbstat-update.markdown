--- 
layout: post
title: Dbstat update
date: 2008-05-22 10:52:02 +01:00
tags: 
- php
- mysql
- dbstat
wordpress_url: general/dbstat-update
---
<p>So I thought maybe it's time for an update.</p>
<p>The project is moving, albeit slowly, and I realy do not like the current PHP implementation, I want to move towards a C++ version, and I will do so as soon as I figure out how to do CLI "update/refresh" ...</p>
<p>i.e. See how W GET works with the progress bar and kbps all in text, I have NO idea how that works.</p>
<p>I am also looking at adding RRDTOOL support.</p>
<p>Anyway here's the current sample output:</p>
<p>{% highlight bash %}[buzz@server01 .sysadmin]$ ./dbstat.php summary{% endhighlight %}</p>
<p>{% highlight bash %}----- mySQL dbStat v1.1 Summary Report-----{% endhighlight %}</p>
<p>{% highlight bash %}10 Databases checked{% endhighlight %}</p>
<p>{% highlight bash %}exampledb1: 13 tables (0 VIEWS 13 INNODB 0 MYISAM) 0.77MB DATA 0.64MB INDEX{% endhighlight %}<br />
{% highlight bash %}exampledb2: 15 tables (0 VIEWS 14 INNODB 1 MYISAM) 0.22MB DATA 0.19MB INDEX{% endhighlight %}<br />
{% highlight bash %}exampledb3: 62 tables (0 VIEWS 0 INNODB 62 MYISAM) 0.45MB DATA 0.5MB INDEX{% endhighlight %}<br />
{% highlight bash %}exampledb4: 3 tables (0 VIEWS 0 INNODB 3 MYISAM) 0.02MB DATA 0.01MB INDEX{% endhighlight %}<br />
{% highlight bash %}exampledb5: 4 tables (0 VIEWS 0 INNODB 4 MYISAM) 0.02MB DATA 0.01MB INDEX{% endhighlight %}<br />
{% highlight bash %}exampledb6: 4 tables (0 VIEWS 0 INNODB 4 MYISAM) 39.81MB DATA 22.22MB INDEX{% endhighlight %}<br />
{% highlight bash %}exampledb7: 3 tables (0 VIEWS 0 INNODB 3 MYISAM) 0.04MB DATA 0.01MB INDEX{% endhighlight %}<br />
{% highlight bash %}exampledb9: 599 tables (8 VIEWS 1 INNODB 590 MYISAM) 8702.79MB DATA 4559.42MB INDEX{% endhighlight %}<br />
{% highlight bash %}exampledb10: 22 tables (0 VIEWS 21 INNODB 1 MYISAM) 6.66MB DATA 2.26MB INDEX{% endhighlight %}</p>
<p></p>

Detail:

{% highlight bash %}----- START mySQL dbStat v1.1 Detail Report: exampledb9 -----{% endhighlight %}
{% highlight bash %}exampledb9: 599 tables (8 VIEWS 1 INNODB 590 MYISAM) 8893.7MB DATA 4583.54MB INDEX{% endhighlight %}
{% highlight bash %}--- Table Index Ratio Report index:data (457 Tables) ---{% endhighlight %}
{% highlight bash %}exampledb9.table1: 315.0769:1{% endhighlight %}
{% highlight bash %}exampledb9.table2: 315.0769:1{% endhighlight %}
{% highlight bash %}exampledb9.table3: 157.5385:1{% endhighlight %}
{% highlight bash %}exampledb9.table4: 146.2857:1{% endhighlight %}
{% highlight bash %}exampledb9.table5: 128.0000:1{% endhighlight %}

... (I've truncated this very long list)

{% highlight bash %}--- Table Fragmentation Report (2 Tables) ---{% endhighlight %}
{% highlight bash %}exampledb9.atable: 0.6067{% endhighlight %}
{% highlight bash %}exampledb9.atable: 0.1285{% endhighlight %}
{% highlight bash %}--- Table Low Size Report (47 Tables) ---{% endhighlight %}
{% highlight bash %}exampledb9.atable: 0 bytes{% endhighlight %}
{% highlight bash %}exampledb9.atable: 0 bytes{% endhighlight %}
{% highlight bash %}exampledb9.atable: 0 bytes{% endhighlight %}
{% highlight bash %}exampledb9.atable: 0 bytes{% endhighlight %}
{% highlight bash %}exampledb9.atable: 0 bytes{% endhighlight %}

... (Truncated again)

{% highlight bash %}--- Table Detail Report (591 Tables) ---{% endhighlight %}
{% highlight bash %}SCHEMA.TABLENAME: ENGINE: ROWS: TOTAL SIZE (MB): DATA SIZE (MB): DATA PERCENTAGE OF TOTAL (%): INDEX SIZE (MB): INDEX PERCENTAGE OF TOTAL (%): LAST UPDATE TIME{% endhighlight %}
{% highlight bash %}exampledb9.a_table: MyISAM: 28906414: 3272.43531003: 3031.82567548: 92.6474: 204.63809450: 7.3526: 2008-05-22 11:59:42{% endhighlight %}

.. (truncated)

{% highlight bash %}----- END mySQL dbStat v1.1 Detail Report: exampledb9 -----{% endhighlight %}
