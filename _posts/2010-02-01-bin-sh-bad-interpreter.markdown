--- 
wordpress_id: 816
layout: post
title: "/bin/sh: bad interpreter"
date: 2010-02-01 11:41:58 +00:00
tags: 
- linux
- php
- interpreter
- bad
categories: 
- uncategorized
wordpress_url: http://saiweb.co.uk/uncategorized/bin-sh-bad-interpreter
---
For security newer distros of RHEL and their derivatives an mounting /tmp with the noexec option.

Now if you have ever had to clean up a compromised web app you can see why this makes a lot of sense, and if not here's a quick example.

Yours/Clients web app becomes compromised, running kernel has a buffer overflow that can lead to privilege escalation, attack writes out their code and compiles in /tmp, then runs said app from /tmp creating a pseudo root level shell, aka you've just been root kitted.

However there are legitimate reasons for using /tmp to compile, well I say legitimate, what I in fact mean is things like pecl, which you use to install extensions like APC require this ...

workaround:

[cc lang="bash"]
export TMPDIR='/a/paTh/your/user/can/write/to'
[/cc]

Failing that:

<strong>service httpd stop</strong>

<strong>DO NOT ALLOW ANY WEBAPP ACCESS WHILE NOEXEC IS IN USE!</strong>

[cc lang="bash"]
mount -o,remount,rw,exec /tmp
pecl install apc
mount -o,remount,rw,noexec /tmp
[/cc]


<strong>DO NOT REMOVE THE NOEXEC OPTION IN /ETC/FSTAB PERMANENTLY YOU WILL REGRET DOING SO</strong>
