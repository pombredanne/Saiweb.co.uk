--- 
layout: post
title: Telnet - SMTP
tags: 
- telnet
- smtp
---
To test a POP3 connection using telnet open a command window or shell terminal and type the following

<code>
telnet smtp.domain.com 25
</code>

Where smtp.domain.com is the FQDN (Fully Qualified Domain Name) or IP address of the server you wish to test.

25 also assumes default SMTP configuration.

You will be greeted with something similar to:

<code>
Escape character is '^]'.
220 smtp.domain.com
</code>

Now you need to enter the HELO command, followed by an idenfication of the server you ar esending from.

<code>
HELO buzz.domain.com
250 smtp.domain.com
</code>

Anything other than "250" indicates a problem.

You can now proceed with the test email transaction.

<code>
MAIL FROM: buzz@buzz.domain.com
250 Ok
RCPT TO: buzz@smtp.domain.com
250 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
This is where the data goes, you finish the input by placeing a dot (.) on a single line.


.
250 Ok: queued as D9FA03705C9
QUIT
221 Bye
Connection closed by foreign host.
</code>
