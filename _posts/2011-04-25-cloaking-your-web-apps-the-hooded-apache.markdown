--- 
layout: post
title: Cloaking your web apps - The hooded Apache
tags: 
- security
- linux
- apache
- hacking
date: "2011-04-25"
---
<p>Go ahead and run</p>
<p><code bash>
curl -I http://www.saiweb.co.uk
</code></p>
<p>You will get </p>
<p><code>
HTTP/1.1 200 OK
Date: Mon, 25 Apr 2011 19:33:29 GMT
Server: Apache
Vary: Accept-Encoding,Cookie
Cache-Control: max-age=3, must-revalidate
WP-Super-Cache: Served supercache file from PHP
Connection: close
Content-Type: text/html; charset=UTF-8
</code></p>
<p>As an attacker looking to hit a web app, one of the first things you're going to want to look into is what version of web server is running, in this case you can see this blog in fact runs apache ... but there is not much else to go on here is there.</p>
<p>That's intentional, and by manual configuration changes I have put in place, this is not the case of a default LAMP install, take for instance, this snippet from another website,</p>
<p><code>
Server: Apache/2.2.16 (Debian)
X-Powered-By: PHP/5.2.14
</code></p>
<p>This already has given me a wealth of information to go on and begin prepping an attack, I now know the site is running php version 5.2.14 Apache version 2.2.16 and that the underlying OS is Debian.</p>

See the dilemma? your default roll outs are just declaring their running versions to anyone willing to listen, so lets make it a little more stealthy.

First and foremost if you are using php, edit your php.ini and set the following:

<code>
expose_php = off
</code>

Now head into your httpd.conf and set the following

<code>
ServerTokens prod
</code>

and

<code>
ServerSignature off
</code>

With these 3 simple steps all the headers will now return is Server: Apache this is the first step to shielding your app, I'll be covering further steps as time allows.


