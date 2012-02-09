--- 
layout: post
title: mod_authz_svn / mod_dav_svn prompting for password
tags: 
- svn
- wtf
- mod_dav_svn
- mod_authz_svn
- fucked
- broken
- fubar
- authzsvnnoauthwhenanonymousallowed
---
Strangely I've had some people reporting issues with being <a href="http://trac.saiweb.co.uk/saiweb/ticket/68">prompted for a username and password when accessing files on svn.saiweb.co.uk 
</a>

it would appear in mod_dav_svn-1.4.2-4.el5_3.1 that this directive: AuthzSVNNoAuthWhenAnonymousAllowed

now defaults to OFF, well that was a p.i.t.a trying to track down, having never seen that directive in ANY of the documentation ...

Anyway pass this on to other facing the same issue.

