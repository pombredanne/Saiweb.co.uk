--- 
wordpress_id: 897
layout: post
title: Enable logging in the SFTP subsystem
date: 2010-07-19 17:48:05 +01:00
tags: 
- ssh
- sftp
- sshd
- logging
categories: 
- linux
wordpress_url: http://saiweb.co.uk/linux/enable-logging-in-the-sftp-subsystem
---
This is something I have wanted to get working for some time now, and thanks to James P for passing me a note that as of OpenSSH 4.4 you can infact add command line args for the Subsystem configuration, which when combined with the  (I assume new) logging functionality of the sftp-service allows you to finally log what is occuring during an sftp session.

Note: Requires OpenSSH >= 4.4

Replace the susbsystem line in your /etc/ssh/sshd_config with

[cc lang="bash"]
Subsystem	sftp	/usr/libexec/openssh/sftp-server -f LOCAL5 -l INFO
[/cc]

Add the following to /etc/syslog.conf

[cc lang="bash"]
#sftp logging
local5.*						/var/log/sftpd.log
[/cc]

Restart the sshd and syslog services, try an sftp upload and review the logs @ /var/log/sftpd.log
