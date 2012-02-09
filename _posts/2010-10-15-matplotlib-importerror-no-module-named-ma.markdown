--- 
layout: post
title: "matplotlib ImportError: No module named ma"
tags: 
- mac
- osx
- matplotlib
- ma
- "no"
- module
- named
date: "2010-10-15"
---
ImportError: No module named ma

Fix is to edit the following files:

[cc lang="bash"]sudo vi /Library/Python/2.6/site-packages/matplotlib-0.91.1-py2.6-macosx-10.6-universal.egg/matplotlib/numerix/ma/__init__.py
sudo vi /Library/Python/2.6/site-packages/matplotlib-0.91.1-py2.6-macosx-10.6-universal.egg/matplotlib/numerix/npyma/__init__.py[/cc]

On my installed on lines 16 and 7 respectively replace


[cc lang="python"]
from numpy.core.ma import *
[/cc]

with

[cc lang="python"]
from numpy.ma import *
[/cc]

and done.
