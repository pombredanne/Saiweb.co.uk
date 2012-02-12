--- 
wordpress_id: 660
layout: post
title: Python urllib2, basic http authentication
date: 2009-06-03 11:43:27 +01:00
tags: 
- python
- urllib2
- http
- basic
- auth
categories: 
- python
wordpress_url: http://saiweb.co.uk/python/python-urllib2-basic-http-authentication
---
I meant to write this up over a week ago now, basically the need arose for one of my Python scripts to use HTTP Basic authentication when grabbing the output from a URL.

An example script can be seen below:

Quick description, the script will attempt to connect to a URL and read the data supplied by the webserver, if a HTTP 401 error is returned (Authentication required) the script will then go on to attempt to authenticate using the credentials supplied.

Printing out to the console at each point.

Subversion:<a href="http://svn.saiweb.co.uk/branches/python/urllib2_httpbasic_auth.py"> http://svn.saiweb.co.uk/branches/python/urllib2_httpbasic_auth.py</a>

Highlighted source (at the time of writing)

[cc lang="python"]
#!/usr/bin/env python
"""
    Author: David Busby (http://saiweb.co.uk)
    Program: Python HTTP Basic Auth Exa
    Copyright: David Busby 2009. All rights reserved.
    License: http://creativecommons.org/licenses/by-sa/2.0/uk/
"""

import urllib2, base64

""" URL List """
urls = {
               0:{"url":"www.saiweb.co.uk/some/fictional/auth/area","user":"someuser","pass":"somepass"}
}

def main():
   ulen = len(urls)
   for i in range(0,ulen):
       url = "http://%s" % (urls[i]["url"])
       req = urllib2.Request(url)
       try:
           res = urllib2.urlopen(req)
           headers = res.info().headers
           data = res.read()
       except IOError, e:
            if hasattr(e, 'reason'):
                err = "%s ERROR(%s)" % (urls[i]["url"],e.reason)
                print err
            elif hasattr(e, 'code'):
                if e.code != 401:
                    err = "%s ERROR(%s)" % (urls[i]["url"],e.code)
                    print err
                #401 = auth required error
                elif e.code == 401:
                    base64string = base64.encodestring('%s:%s' % (urls[i]["user"], urls[i]["pass"]))[:-1]
                    authheader =  "Basic %s" % base64string
                    req.add_header("Authorization", authheader)
                    try:
                        res = urllib2.urlopen(req)
                        headers = res.info().headers
                        data = res.read()
                    except IOError, e:
                        if hasattr(e, 'reason'):
                            err = "%s:%s@%s ERROR(%s)" % (urls[i]["user"],urls[i]["pass"],urls[i]["url"],e.reason)
                            print err
                        elif hasattr(e, 'code'):
                            err = "%s:%s@%s ERROR(%s)" % (urls[i]["user"],urls[i]["pass"],urls[i]["url"],e.code)
                            print err
                    else:
                        err = "%s query complete" % (urls[i]["url"])
                        print err
       else:
            err = "%s query complete" % (urls[i]["url"])
            print err
                        
if __name__ == "__main__":
    main()
[/cc]

<strong>NOTES:</strong> This script does not check the authentication type, it always assumes it is HTTP BASIC, HTTP DIGEST for example is not compatible with this script, though there is no reason why you can not get the Auth type form the headers returned by the server and write in a Digest auth method.
