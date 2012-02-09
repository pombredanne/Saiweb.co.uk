--- 
layout: post
title: Cloaking your web apps - Ninja vanish
tags: 
- security
- hacking
- web
- apps
- cloak
- hide
---
Bad <a href="http://lmgtfy.com/?q=tmnt">TMNT</a> reference I know but with a reboot coming what do you expect realy?

Right so you have hidden your versions via <a href="http://www.saiweb.co.uk/security/cloaking-your-web-apps-the-hooded-apache">The Hooded Apache</a> so what now?

Well no matter what you do if your url's contain .php / .asp / .cfm (Frankly if you are using coldfusion you deserve what you get ... just saying ...)

You are disclosing what your webapp is using as it's server side language, now to be clear this hiding is only going to be effective if you are using a bespoke webapp, and not say Joomla / Wordpress as they are easily identifiable via other means (for another post) ...

<strong>mod_rewrite</strong>

Learn this, I mean seriously not only can it help cloak your server side language but you can do so using <a href="http://lmgtfy.com/?q=SEO">SEO</a> urls.

<strong>BUT</strong> be careful if you think you're being cleaver by having mod_rewrite change the extension alone ...

[cc]
RewriteEngine On
RewriteRule (.*)\.inc$ $1.php [L]
[/cc]

it will be easy to enumerate the back end language this way ... the first 404 that an attacker gets when enumerating your file names will reveal this rule i.e. 

"The file /asfasdgasdg.php was not found on this server" ... yeh ...

<strong>Change the extension entirely</strong>

Security through obscurity? you bet your ass, just add your new extension onto your AddType declaration, because you are already avoiding the <a href="http://www.saiweb.co.uk/uncategorized/apache-2-2-3-dual-extention-vulnerability">dual extension vulnerability</a> right? 

how about .wtf

[cc]
AddType application/x-httpd-php .php .phtml .wtf
[/cc]

Now just name your files .wtf instead of .php

<strong>So your using subversion</strong> good for you! you can use subversion as part of PCI 11.5 (iirc) to enforce file integrity assuming of course you have your subversion deploy setup securely just one tiny problem ...

[cc]
curl -s http://domain.com/.svn/entries

10
dir
1234
http://domain.com/PROJECT/tags/1.0
http://domain.com

2011-06-15T11:47:29.153442Z
1234
joe.blogs
has-props

9733698e-0000-0000-abab-ab0000000aba
^L
config.php
file

ddde986004c962d5827ca851403f96d5
2011-05-25T08:13:14.961921Z
1234
joe.blogs
[/cc]
<strong>
Seemingly innocent right? oh how wrong you are ...</strong>

<ol>
	<li>http://domain.com we know the version control server location, we can attack that later</li>
	<li>http:// is not an encrypted protocol, easy to sniff for if you get access to the server / company lan</li>
	<li>joe.blogs we have a known username we can attempt to access using dictionary / brute force / social engineering</li>
	<li>http:// the server could be vulnerable to <a href="http://www.cvedetails.com/cve/CVE-2011-1921/">CVE-2011-1921</a> </li>
	<li>we know that config.php exists we can target that later for other crednetials</li>
</ol>

<strong>So assuming a worst case scenario, </strong>

<ol>
	<li>Webapp is compromised and we managed to deploy a remote shell</li>
	<li>Sniffing for http:// hiding silently in the background we find a site update / commit, and snag joe.blogs user credentials</li>
	<li>Exploiting <a href="http://www.cvedetails.com/cve/CVE-2011-1921/">CVE-2011-1921</a> we enumerate all projects on the svn server (If we even have to ... joe.blogs could have access to everything anyway ...)</li>
	<li>Inject backdoors into all projects committing changes as joe.blogs</li>
	<li>Wait for co	de to be deployed to production ...</li>
	<li>And now you have backdoors into multiple projects</li>
</ol>

<strong>You can prevent this by ...</strong>

[cc]
<Directory ~ "\.svn">
Order allow,deny
Deny from all
</Directory>
[/cc]

<strong>Or using mod_security</strong>

[cc]
SecRule REQUEST_URI "\.svn" phase:1,deny
[/cc]

Ensure you use an <strong>ENCRYPTED</strong> protocol for your version control https:// / ssh+svn:// for example with subversion.

