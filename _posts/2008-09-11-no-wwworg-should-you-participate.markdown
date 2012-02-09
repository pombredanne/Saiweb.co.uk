--- 
layout: post
title: no-www.org should you participate?
tags: 
- no-www
---
This question has arrived at my feet a few times now.

Sould I participate with http://no-www.org/ and remove support for www. on my sites?

The answer is <b>no you shouldn't</b> whilst I appreciate and do belive www. has become deprecated, a LOT of end users still use www. So by removing support for this you are excludinga potentialy large user base from reaching your website, can you as a business afford to do that ... of course not!

So what _should_ you do?

In my opinion, add support for both.

You will see that http://saiweb.co.uk and http://www.saiweb.co.uk BOTH work, this allows both "classes" of end users to reach my website, and I have applied this principle to all sites I have recently worked on.

Example httpd.conf entry

ServerName saiweb.co.uk
ServerAlias www.saiweb.co.uk

DNS for saiweb.co.uk is an A record to the IP of my webhost and www.saiweb.co.uk is a CNAME of saiweb.co.uk

This method however does not http://no-www.org/ validate as www. subdomain still exists, so don't expect a "no-www" validated image to appear on my blog anytime soon.

www. may be depreciated, but businesses can not afford to exclude any potential customers, so don't expect this no-www to become standard anytime either.

"July 2, 2008

Today we passed 38,000 domains validated through no-www. This is a nice round number so it seems worthy of tooting our horn over. "

As I write this there are 77,343,623 active domains (source: <a href="http://www.domaintools.com/internet-statistics/">http://www.domaintools.com/internet-statistics/</a>) making the no-www support less than 0.05% of active domains.

I would be intrested to know how many of this 38k domains are actual businesses, and how support no-www has affected thier online sales.

I can tell you however of the 300 or so domains I currently controll, non would no-www validate as they are all configured using the method above.

Thoughts?
