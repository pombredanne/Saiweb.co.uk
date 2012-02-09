--- 
layout: post
title: Syntax highlighting vi for rhel/centos
tags: 
- centos
- vi
- vim-enhanced
- syntax
- highlight
- rhel
date: "2010-04-06"
---
The default install of VI is very basic, and being as I spend a lot of my time in there I find syntax highlighting invaluable, to get this however you will need the vim-enhanced package.

So run the following to install this package and setup an alias for vi.

[cc lang="bash"]
yum install vim-enhanced
echo "alias vi='/usr/bin/vim'" >> ~/.bashrc
echo "syntax on" >> ~/.vimrc
alias vi='/usr/bin/vim'
[/cc]

And you're done:

<a href="http://cdn.saiweb.co.uk/uploads/2010/04/2010-04-06_1649.png"><img class="alignnone size-full wp-image-849" title="vi-syntaxt-highlight" src="http://cdn.saiweb.co.uk/uploads/2010/04/2010-04-06_1649.png" alt="" width="201" height="92" /></a>
