--- 
layout: post
title: "php mail() sh: -t command not found"
tags: []

---
PHP mail() not working?

getting "sh: -t: command not found" when testing using the cli?
what you have is a missing devel package!!!!

In my case sendmail-devel was missing, you'd think the configure script would alert on this but alas no, devel pack installed and one recompile later and the issue is solved.


