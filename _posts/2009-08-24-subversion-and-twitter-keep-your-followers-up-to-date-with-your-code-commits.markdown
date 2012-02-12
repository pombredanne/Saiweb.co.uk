--- 
wordpress_id: 738
layout: post
title: Subversion and twitter - Keep your followers up to date with your code commits
date: 2009-08-24 12:23:46 +01:00
tags: 
- svn
- twitter
- subversion
- hooks
- post-commit
categories: 
- python
- twitter
wordpress_url: http://saiweb.co.uk/python/subversion-and-twitter-keep-your-followers-up-to-date-with-your-code-commits
---
Some two months after the fact, I thought it may well be time to post a blog on this little code snippet.

As some of you have noticed every commit message to my subversion repository is infact updating my twitter.

This code was uploaded to subversion on 10/06/2009, so sorry for the late write up!
<strong>
Requirements</strong>

Python 2.5 or higher
Subversion server

<strong>Installation</strong>
<ul>
	<li>svn co http://svn.saiweb.co.uk/branches/python/svn_tweeter.py /usr/bin/svn_tweeter</li>
	<li>chmod +x /usr/bin/svn_tweeter</li>
	<li>cd /path/to/svn/hooks</li>
	<li>Edit post-commit with your favorite text editor</li>
</ul>
{% highlight bash %}
REPOS="$1"
REV="$2"{% endhighlight %}

{% highlight bash %} {% endhighlight %}

{% highlight bash %}/usr/bin/python /usr/bin/svn_tweeter -u twitterusername -p twitterpassword -r $REV -s $REPOS
{% endhighlight %}

Now try a commit, and check your syslog for entries from the script.

Aug 24 11:36:26 132 python: SVN_TWEETER: http://twitter.com/statuses/update.json query complete

<strong>UPDATE 24/03/2011</strong> Twitter has removed basic authentication, you must use oauth (admittedly it has been like this for a fair while now) use this <a href="https://github.com/Oneiroi/nagios_addons/blob/master/twitter/nagios_bot.py">nagios_bot</a> instead
