--- 
wordpress_id: 892
layout: post
title: Linux collection of handy scripts and one liners - Volume 1
date: 2010-07-15 20:15:15 +01:00
tags: 
- linux
- bash
- lhol
- handy
- one
- liners
- scripts
categories: 
- linux
wordpress_url: http://saiweb.co.uk/linux/linux-collection-of-handy-scripts-and-one-liners-volume-1
---
<strong>Ever wanted / needed HTTPD or another service to run with a raised thread priority?</strong>

Well you have a couple of options, add additional lines to the /etc/init.d script to change the <a href="http://linux.about.com/library/cmd/blcmdl1_nice.htm">nice</a> level by adding additional lines on startup, or if you only need to do this on a temporary basis without restarting the service but need every thread to have a raised priority you can use a bash script 

{% highlight bash %}
#!/bin/bash
PIDS=`ps aux | grep httpd | grep -v 'grep' | awk '{print $2}'`;
for PID in ${PIDS[@]}
do 
        renice 20 -p $PID
done
{% endhighlight %}

You can renice between -20 and +20, depending on your requirements you can use this script in a cron job  to raise/lower priorities, change httpd for whatever service you want to change the thread priority for.

<strong>Ever needed to check files were being accessed / written to?</strong>

For this one you're going to need the <a href="http://wiki.github.com/rvoicilas/inotify-tools">inotify-tools</a> package, specifically the inotifywait binary.

{% highlight bash %}
inotifywait -m --timefmt "[%a %b %d %H:%M:%S %Y]" --format "%T [%e] %f" -r /folder/to/watch
{% endhighlight %}

An example usage is to ensure that caching is working correctly and that cache files are being used in place of processing PHP files, simply change "/folder/to/watch" to be your cache folder, and refresh a few pages.

All being well you'll get an output similar to the following:

{% highlight bash %}
y-tools-3.14)
(root@132 BUZZ1) # /usr/local/bin/inotifywait -m --timefmt "[%a %b %d %H:%M:%S %Y]" --format "%T [%e] %f" -r /path/to/saiweb/wp-content/cache/supercache/*
Setting up watches.  Beware: since -r was given, this may take a while!
Watches established.
[Thu Jul 15 20:59:37 2010] [OPEN] index.html
[Thu Jul 15 20:59:37 2010] [CLOSE_NOWRITE,CLOSE] index.html
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] 
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] security
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] 
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] vsftpd-chrooting-without-the-headache-allowing-shared-directories
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] 
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] vsftpd-chrooting-without-the-headache-allowing-shared-directories
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] 
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] the-zen-of-secured-shared-hosting-part-1
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] 
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] the-zen-of-secured-shared-hosting-part-1
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] 
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] php-security-considerations
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] 
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] php-security-considerations
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] 
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] antivirus-xp-2008-removal
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] 
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] antivirus-xp-2008-removal
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] 
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] suphplookupexception
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] 
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] suphplookupexception
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] 
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] honeypotting-for-viruses-statement-of-fees-200809
[Thu Jul 15 21:00:08 2010] [OPEN,ISDIR] 
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] honeypotting-for-viruses-statement-of-fees-200809
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] 
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR] security
[Thu Jul 15 21:00:08 2010] [CLOSE_NOWRITE,CLOSE,ISDIR]
{% endhighlight %}

As can be seen the re-write rules are redirecting users to the cached files/folders, in the example above I have used my <a href="http://wordpress.org/extend/plugins/wp-super-cache/">wp-supercache</a> folder.

<strong>Ever needed to quickly get the memory usage of all threads for a service?</strong>

You have two options for this a single line

{% highlight bash %}
 ps -Ao rsz,comm,pid | grep <process name>
{% endhighlight %}

or a bash function you can place in your ~/.bashrc

{% highlight bash %}
function appmem(){
	if [ -z "$1" ]; then
		echo "appmem <string to filter>"
		echo "i.e. appmem httpd";
	else
		ps -Ao rsz,comm,pid | grep $1
	fi
}
{% endhighlight %}

You can then call this (after logging back in again to load the .bashrc up) using

{% highlight bash %}
appmem <filter>
{% endhighlight %}

replacing <filter> for instance with httpd will give you an output similar to the following:

{% highlight bash %}
8032 httpd            6207
33080 httpd           13828
 8552 httpd           14095
28952 httpd           14102
 8540 httpd           14103
30848 httpd           16741
31296 httpd           16832
30452 httpd           18439
31044 httpd           19996
30968 httpd           23287
30356 httpd           23300
25636 httpd           24553
29712 httpd           24771
25588 httpd           24777
31632 httpd           24778
25608 httpd           24796
29716 httpd           24812
28152 httpd           24813
31684 httpd           31291
{% endhighlight %}

This shows memory in kilobytes, command, process id, you can see here I currently have 3mb/pid for each httpd process (due to <a href="http://www.saiweb.co.uk/linux/optimizing-apache-for-high-load-sites-part-3">my optimizations</a>, I highly recommend you read parts 1-3)

<strong>Dump mysql data and compress on the fly</strong>

{% highlight bash %}
mysqldump -h <host> -u <user> -p <dbname> | bzip2 -c7 > /path/to/dump.sql.bz2
{% endhighlight %}

Self explanatory that one, pipes the output from mysqldump through bzip2 (which has better compression over gzip) and dumps it out to a file, if you _realy_ need a gziped file just replace bzip2 with gzip in the line above. 

<strong>Ever needed a selection of passwords generated?</strong>

For this one you can use the <a href="http://linux.die.net/man/1/secpwgen">secpwgen</a>

{% highlight bash %}
function pwgen(){
        for (( i=0; i<=10; i++ )) do pwd=`secpwgen -Aadhs 10 2>&1 | grep ENTROPY | awk '{print $1}';`; echo "$i: $pwd"; done;   
}
{% endhighlight %}

Plant this in your ~/.basrc for a callable function that will genrate a selection of 10 secure passwords, handy when you're fed up of 1337'ifying everything

example output:

{% highlight bash %}
0: 4>&B.\2R+--
1: )`WREEGZP{
2: ^)3"=F==|?0
3: ?1/|;;GF-2
4: [..///_([=AZ
5: }^%RC~U8//L
6: \//VNTQ[)->
7: @HE5@3)A%?
8: )|1C[BSIT*
9: C[//X^W<$G1
10: EOQ#Y%NI>-
{% endhighlight %}

Modify the "-Aadhs" args to your taste.


This concludes Volume 1 and a very long post, please contribute your one liners / helper scripts via the comments.

Cheers

buzz
