--- 
wordpress_id: 438
layout: post
title: Bash Hello World in 60 seconds
date: 2009-01-19 11:49:08 +00:00
tags: 
- bash
- hello world
categories: 
- linux
- bash script
wordpress_url: http://saiweb.co.uk/linux/bash-hello-world-in-60-seconds
---
How to write a bash 'hello world' script in 60 seconds, admitedly it could of been faster ... damn typos


Also the first line you can add as an alias, if your going to be writing a lot of bash scripts.


[FLOWPLAYER=bash_hello_world.mp4,600,200]

Or you can copy paste and have it done in about 5 seconds :-P

{% highlight bash %}
BPATH=`which bash`; echo "#! $BPATH" | awk '{print $1$2}' > script.sh
{% endhighlight %}

The reason for the echo and awk is when trying to do echo "#!$BPATH" > script.sh my shell wouldn't cooperate so all the awk does is take out the space :-).

