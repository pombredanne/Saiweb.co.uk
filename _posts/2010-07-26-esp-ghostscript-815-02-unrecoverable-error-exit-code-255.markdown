--- 
layout: post
title: "ESP Ghostscript 815.02: Unrecoverable error, exit code 255"
date: 2010-07-26 11:46:16 +01:00
tags: 
- image
- magic
- imagick
- exit
- unrecoverable
- "255"
- ghostscript
wordpress_url: linux/esp-ghostscript-815-02-unrecoverable-error-exit-code-255
---
<strong>ESP Ghostscript 815.02: Unrecoverable error, exit code 255</strong>

I got this issue today whilst running CentOS 5.4 x64 post investigation of images not being scaled when processing a specific PDF, the solution unfortunately is to build ghostscript and imagemagick from the latest sources.

[cc lang="bash"]
wget http://ghostscript.com/releases/ghostscript-8.71.tar.gz
wget http://image_magick.veidrodis.com/image_magick/ImageMagick-6.6.3-0.tar.gz
[/cc]

Unpack, configure, make && make install

To fix compatibility with pear imagick

[cc lang="bash"]
ln -s /usr/local/lib/libMagickCore.so /usr/lib64/libMagick.so.10
ln -s /usr/local/lib/libMagickWand.so /usr/lib64/libWand.so.10
ln -s /usr/local/bin/gs /usr/bin/gs
[/cc]
