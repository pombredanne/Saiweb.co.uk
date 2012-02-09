--- 
layout: post
title: suPHP::LookupException
tags: 
- suphp
- lookupexception
- suphp::lookupexception
---
If you are seeing '<b>suPHP::LookupException</b>' in your apache error logs, this is due to the <b>suPHP_UserGroup</b> line in your virtualhost config.


This error indicates that the user and/or the group specified in the config does not exist, this can happen if you have typed in either incorrectly, and/or the user has been removed from the system (see /etc/passwd).
