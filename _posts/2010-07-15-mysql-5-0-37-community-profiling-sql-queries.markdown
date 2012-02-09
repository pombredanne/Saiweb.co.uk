--- 
layout: post
title: mySQL >= 5.0.37 community profiling SQL queries.
tags: 
- mysql
- query
- slow
- sql
- slow query
- profiling
- community
- 5.0.37
---
Whilst there indeed seems to be a veritable plethora of SQL profiling / benchmarking tools, most of them with insane commercial license fees (&gt;= $400 per annum on most)

I have found it intriguing that as of mySQL community edition &gt;= 5.0.37 mySQL offers an inbuilt method for profiling SQL queries, as can be see <a href="http://dev.mysql.com/doc/refman/5.0/en/show-profiles.html">here</a> the downside is that this is session based, meaning it can only provide profiling information for the current connection, almost useless for trying to profile a running web app (that is without code modification to set profiling and harvest the data).

However it can be useful if you have a known slow query.

So lets work on the basis that we have a known slow SQL query we'd like profiling information for,

check to see if profiling is enabled:

[cc lang="sql"]
select  @@profiling;
[/cc]

The returned value is generally 0 so lets enable it.

[cc lang="sql"]
set profiling_history_size=100;
set profiling=1;
[/cc]

This tells mySQL to retain the profile of 100 queries in memory, and to enable profiling.

Now at this point this can also be used to diagnose slow loading datases, simply

[cc lang="sql"]
use <dbname>;
show profiles;
show profile for 1;
[/cc]

Upon running the above you will now be using your database and will see an output similar to

<code>
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00011400 | SELECT DATABASE() |
|        2 | 0.00048900 | show databases    |
|        3 | 0.00026600 | show tables       |
+----------+------------+-------------------+
</code>

Followed by

<code>
+----------------------+----------+
| Status               | Duration |
+----------------------+----------+
| starting             | 0.000053 |
| checking permissions | 0.000004 |
| Opening tables       | 0.000009 |
| init                 | 0.000011 |
| optimizing           | 0.000004 |
| executing            | 0.000017 |
| end                  | 0.000003 |
| end                  | 0.000002 |
| query end            | 0.000002 |
| freeing items        | 0.000005 |
| logging slow query   | 0.000002 |
| cleaning up          | 0.000002 |
+----------------------+----------+
</code>
In my case here nothing really eventful, lets assume for the moment you are using a wordpress database, and you have numerous posts

[cc lang="sql"]
select count(*) from wp_posts where ID > 100
select count(ID) from wp_posts where ID > 100
[/cc]

in my case I got the following results:

<code>
0.00072600 | select count(*) from wp_posts where ID &gt; 100
0.00069900 | select count(ID) from wp_posts where ID &gt; 100
</code>

a simple demonstration showing the difference between a count() on an indexed field vs *, in this case the saving is ~4%.

[cc lang="sql"]
show profiles;
show profile for query <n>;
[/cc]

Will give you an output similar to:

<code>
+--------------------+----------+
| Status             | Duration |
+--------------------+----------+
| starting           | 0.000079 |
| Opening tables     | 0.000014 |
| System lock        | 0.000005 |
| Table lock         | 0.000008 |
| init               | 0.000025 |
| optimizing         | 0.000012 |
| statistics         | 0.000049 |
| preparing          | 0.000012 |
| executing          | 0.000006 |
| Sending data       | 0.000461 |
| end                | 0.000004 |
| end                | 0.000003 |
| query end          | 0.000003 |
| freeing items      | 0.000007 |
| closing tables     | 0.000005 |
| logging slow query | 0.000003 |
| cleaning up        | 0.000003 |
+--------------------+----------+
17 rows in set (0.00 sec)
</code>

this is very similar to a <a href="http://en.wikipedia.org/wiki/Strace">stack trace</a> you may run on a problematic script, or <a href="http://www.xdebug.org">xdebug</a> + <a href="http://code.google.com/p/webgrind/">webgrind</a>, and will gain futher insight into your SQL should <a href="http://dev.mysql.com/doc/refman/5.0/en/explain.html">EXPLAIN</a> no give you enough of an insight.

I'll post more information on this as I get time to work with it more, this is still knew to me, and aside from knowing how to use it I know relatively little about this profiling functionality, please feel free to post references / examples in the comments.

Cheers

Buzz
