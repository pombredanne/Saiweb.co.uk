--- 
layout: post
title: "Make your webapp shine with varnish \xE2\x80\x93 Part 2 backends"
date: 2011-06-18 12:09:39 +01:00
tags: 
- cache
- varnish
- high
- performance.
wordpress_url: linux/make-your-webapp-shine-with-varnish-%e2%80%93-part-2-backends
---
Pre-req reading: <a href="http://www.saiweb.co.uk/linux/make-your-webapp-shine-with-varnish-part-1">Part 1</a>

In this part we will cover setting up a backend. A backend is your application server, whether this be apache / nginx / iis (IIS - <strong>I</strong>s <strong>I</strong>nherently <strong>S</strong>tupid) you are telling varnish where it should sends it's requests to.
<strong>
Very basic configuration</strong>
[cc]
.backend app1 {
    .host = "127.0.0.1";
    .port = "8080;"
}
[/cc]

For a quick start that's it really you tell varnish a backend and the port to connect to it on ... just make sure you use it in vcl_recv, but you're not here for simple and quick start are you? lets add the following.

<ul>
	<li>timeout settings</li>
	<li>probe settings</li>
</ul>


<strong>Timeout settings</strong>

Your timeout settings deinf how long varnish should wait for a response from your backend 

[cc]
.backend app1 {
    .host = "127.0.0.1";
    .port = "8080;"
    .connect_timeout = 0.05s;
    .first_byte_timeout = 2s;
    .between_bytes_timeout = 2s;
}
[/cc]

<ul>
	<li><strong>connect_timeout</strong> wait 50ms for a tcp connection to take place</li>
	<li><strong>first_byte_timeout</strong> wait 2s for the first byte of data to be sent from the backend</li>
	<li><strong>between_bytes_timeout</strong> wait 2s if there is a pause mid data stream</li>
</ul>

Timeouts are a basic way of determining if a backend is down / miss behaving if you have multiple backends if timeouts occur then the backend is marked as sick and the other backends will be used.

<strong>probe settings - Trust me I'm a doctor</strong>

[cc]

.backend app1 {
    .host = "127.0.0.1";
    .port = "8080;"
    .connect_timeout = 0.05s;
    .first_byte_timeout = 2s;
    .between_bytes_timeout = 2s;
    .probe = {
	.url = "/status.html";
	.timeout = 0.05s;
	.window = 5;	
	.threshold = 3;	#60% of last checks must of been OK for this backend to be healthy
	.interval = 2s;	#how often to run the checks
    }
}
[/cc]

<ul>
	<li><strong>url</strong> the URL to to query this must return a 200 OK response, you could use a php script to return a 500 on say a mySQL outage</li>
	<li><strong>timeout</strong> how long to wait for a 200 OK response from the URL</li>
	<li><strong>window</strong> keep the result of the last 5 probes in memory</li>
	<li><strong>threshold</strong> how many of the window total must be OK for the backend to be "healthy"</li>
	<li><strong>interval</strong> how often to run the probe</li>
</ul>

And that about wraps up this post.
