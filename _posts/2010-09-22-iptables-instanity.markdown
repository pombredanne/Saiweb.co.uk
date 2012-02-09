--- 
layout: post
title: iptables instanity
tags: 
- wtf
- iptables
- rate
- limit
- b0rk
---
Namely a bug to do with iptables rate limiting,

[cc lang="bash"]
iptables -I INPUT 2 -p tcp --dport http -m state --state NEW -m recent --update --seconds 60 --hitcount 20 -j LOG --log-level=7
[/cc]
works!

[cc lang="bash"]
iptables -I INPUT 2 -p tcp --dport http -m state --state NEW -m recent --update --seconds 60 --hitcount 60 -j LOG --log-level=7
iptables: Unknown error 18446744073709551615
[/cc]

-j REJECT also produces the same.

Simply increasing the "hitcount" causes this error, the only work around I have come up with is decreasing the --seconds arg, to yield more hits/sec, still bloody annoying!


