--- 
layout: post
title: php 4.3.10 html_entity_decode() crash
tags: 
- php
- crash
---
Just as a warning and as a poke to say WHY are you not running PHP 5.x yet.

Parsing "" and it seems some multibyte chars to html_entity_decode() in PHP 4.3.10 will cause it to crash, returning random memory contents.

In my case some contents in memory from other sites running on the box were returned.
