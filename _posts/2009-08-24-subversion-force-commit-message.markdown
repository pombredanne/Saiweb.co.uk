--- 
layout: post
title: Subversion - Force commit message
tags: 
- subversion
- force
- commit
---
Again this is a late blog post about some code committed several months ago, in this case the code was committed 09/06/2009 

It is a very short python script to force a subversion commit message to be greater than 10 characters in length

<strong>Installation:</strong>

svn export <a href="http://svn.saiweb.co.uk/branches/python/svn_force_message.py">http://svn.saiweb.co.uk/branches/python/svn_force_message.py</a> /path/to/your/svn/hooks/pre-commit
chmod +x /path/to/your/svn/hooks/pre-commit

Note installation this way will replace your current pre-commit hooks file.



