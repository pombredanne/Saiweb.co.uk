--- 
layout: post
title: dissecting the hack - psychz.net
tags: 
- force
- brute
- ftp
- psychz
date: "2010-08-25"
---
For some background you may want to read the <a href="http://www.saiweb.co.uk/hacking/when-fail2ban-fails-to-ban-dissecting-the-hack">Original Story</a> leading to this write up.

The first thing that caught my attention was the fact Logwatch was reported login failures in the order of 1000's from unassigned.psychz.net without an accompanying fail2ban email notifying me the offender had been banned.

And this as it would turn out was because the attack was clearly intended to defeat such protection methods, this is due to the logged host being unassigned.psychz.net, when the authentication failure is logged, a reverse lookup is made within vsftpd to resolve the host this PTR record returns unassigned.psychz.net, and as such is written into the log.

fail2ban no uses regex to extract the host from the logs, and attempts to make a forward lookup on unassigned.psychz.net (A/CNAME records required) to resolve the ip address, and ban the offending ip, this is where things go awry.

psychz.net maintains their own DNS servers,
<ol>
	<li>DNS1.PSYCHZ.NET</li>
	<li>DNS2.PSYCHZ.NET</li>
</ol>
These provide a PTR but no A/CNAME record, as such fail2ban can not resolve an IP and the attacking ip is left to run their attack unhindered, see this log file: <a href="http://www.saiweb.co.uk/psychz-260710/fail2ban-grep.log">fail2ban name resolution failure log</a>

The only way therefor to gain the attacking ip was to match the ftp connection times to those of the reported login failures using iptables to log all accesses to ftp, quickly get a count of connecting ip's using:

[cc lang="bash"]
grep kernel /var/log/messages | awk '{print $9}' | sed 's/SRC=//' | uniq -c | sort
[/cc]

<code>
390 173.224.217.41
</code>

A complete log can be found here: <a href="http://www.saiweb.co.uk/psychz-260710/iptables.log">iptables.log</a>, and a whois can be found here: <a href="http://www.saiweb.co.ukcdn.saiweb.co.uk/uploads/2010/08/whois.txt">whois.txt</a>

Disclosure steps taken:
<ol>
	<li>26/07/10 psychz support informed given deadline of 09/08/10 for resolution</li>
	<li>Same day standard reply of "thanks for contacting support we are looking into this" ...</li>
	<li>27/07/0 Attacks continue 173.224.208.0/20 network black holed as a result
[cc lang="bash"]iptables -A INPUT -s 173.224.208.0/20 -j DROP[/cc]
</li>
	<li>09/08/10 deadline passes without update</li>
	<li>25/08/10 this blog post published</li>
</ol>
