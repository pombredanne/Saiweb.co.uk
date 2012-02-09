--- 
layout: post
title: Quickly get MAC addresses in Windows XP using ARP
tags: 
- windows xp
- mac address
- arp
---
<p>Just a quick blog about this ...</p>
<p>Ever had the problem of having to assign a DHCP reservation with no mac address resolving software on your laptop? (NOOB! haha)</p>
<p>Well ... you have software built in if you are using windows XP anyway ...</p>
<p><code>Start > run > cmd</code></p>
<p>"arp -a" (without quotes)</p>
<p>this will list your current local interfaces and thier MAC addresses.</p>
<p>"arp -a xxx.xxx.xxx.xxx" (without quotes) Where xxx.xxx.xxx.xxx is the target IP address on your LAN, this will resolve the MAC address for that interface.</p>
<p>Nice quick and simple.</p>
<p>Enjoy!</p>
<p>UPDATE: If you get an error "NO Arp entries found" when doing this, just ping the IP address first, assuming you get a response you _should_ be able to use arp to lookup the mac address!</p></p>
