--- 
layout: post
title: Adding pyinotify to CentOS 5 x64
tags: 
- centos
- pyinotify
date: "2009-06-16"
---
In order to get pyinotify working on CentOS 5 x64 a few workarounds need to take place.

(Thanks to Matthew Ife at ukFast for help with this)

First off you are going to need the python-ctypes RPM, available from DAG here: <a href="http://dag.wieers.com/rpm/packages/python-ctypes/python-ctypes-1.0.0-2.el5.rf.x86_64.rpm">python-ctypes-1.0.0-2.el5.rf.x86_64.rpm</a>

Once installed you are going to need the Fedora 8 python-inotify SOURCE rpm available from here: <a href="ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/updates/8/SRPMS.newkey/python-inotify-0.8.0-3.r.fc8.src.rpm">python-inotify-0.8.0-3.r.fc8.src.rpm</a>

The easiest way I found to extract the required packages was using the following:
[cc lang="bash"]
mkdir ./python-inotify
cd ./python-inotify
wget ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/updates/8/SRPMS.newkey/python-inotify-0.8.0-3.r.fc8.src.rpm
rpm2cpio ./python-inotify-0.8.0-3.r.fc8.src.rpm | cpio -idv
tar -zxvf ./pyinotify-0.8.0r.tar.gz
cd ./pyinotify
./setup.py install
[/cc]






