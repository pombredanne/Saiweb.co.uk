--- 
layout: post
title: Update twitter in a single line
tags: 
- twitter
date: "2009-03-20"
---
As it turns out twitter account can be updated in a single line, this makes writing "bots" just that little bit easier.

[cc lang="bash"]
/usr/bin/curl --basic --user "username:password" --data-ascii "your tweet" http://twitter.com/statuses/update.json
[/cc]

This also returns JSON should you want to parse the reply data.

i.e.

[cc lang="javascript"]
{"in_reply_to_screen_name":null,"in_reply_to_status_id":null,"truncated":false,"user":{"profile_image_url":"http:\/\/static.twitter.com\/images\/default_profile_normal.png","description":"","followers_count":0,"screen_name":"user","url":null,"name":"user","protected":true,"location":"","id":12345678},"text":"your tweet","favorited":false,"created_at":"Fri Mar 20 11:38:44 +0000 2009","in_reply_to_user_id":null,"id":1359757870,"source":"web"}
[/cc]

At the moment I am looking at hooking this into Nagios, from there the feed will be passed into a 'service status page'.


But in theory this single line could be used for any purpose.
