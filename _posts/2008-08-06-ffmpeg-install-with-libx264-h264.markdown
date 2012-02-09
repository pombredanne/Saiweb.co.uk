--- 
layout: post
title: ffmpeg install with libx264 (h264)
tags: 
- ffmpeg
- h264
- libx264
date: "2008-08-06"
---
The information for this is VERY very sparse, so here is a summary of what I have found.

<b><u>Install libx264</u></b>

Get the libx264 package from here: <a href="http://www.videolan.org/developers/x264.html">http://www.videolan.org/developers/x264.html</a>

Extracts the bz2 file 

<code>
tar -xjvf /path/to/x264-snapshot-20080805-2245.tar.bz2
</code>

And now the useual

<code>
cd /path/to/x264-dir
./configure --enable-shared
make
make install
ldconfig
</code>

Get a nice error message:

<code>
[root@dev01 x264-snapshot-20080805-2245]# ./configure
No suitable assembler found.  Install 'yasm' to get MMX/SSE optimized code.
If you really want to compile without asm, configure with --disable-asm.
</code>

You do want MMX/SSE at somepoint for the time being I am disabling this though (lack of time to find a valid RHEL source). so I added the disable asm line.

<b><u>Install ffmpeg</u></b>

For this I use subversion.

<code>
cd /path/to/where/I/want/sources
svn checkout svn://svn.mplayerhq.hu/ffmpeg/trunk ffmpeg
cd /path/to/where/I/want/sources/ffmpeg
./configure --enable-libx264 --enable-gpl --enable-shared
make
make install
</code>

et voila ffmpeg is now installed with libx264 (h264).

<hr />

<u><b>error while loading shared libraries: libavdevice.so.52: cannot open shared object file: No such file or directory</b></u>

To fix this:

<code>
vi /etc/ld.so.conf.d/custom-libs.conf
</code>

Add the line : /usr/local/lib

And run ldconfig.

<b>UPDATE: </b> I am writing a full set of notes blog entry for installing ffmpeg with codecs on RHEL4
