--- 
layout: post
title: Sysamin - iconv update
tags: 
- python
- iconv
- charset
- conversion
- bom
date: "2009-09-10"
---
I had a major issue facing the iconv functionality of the <a href="http://www.saiweb.co.uk/sysadmin">sysadmin toolset</a> namely due to rushed coding.

When loading a file to be re-encoded the entire file was loaded into the buffer, encoded as whole and written out to the new file, this of course meant the  memory usage was roughly double the size of the file to be converted plus any overheads to do with the encoding itself.

Today I had need to convert a 1.3GB sql file, needles to say the script was crashing out with a memory error.

As such I have now completely re-written the function it now processes the file in 1kb 'chunks', moving the load to the CPU, this process is now very cpu intensive the the memory overhead is minimal (during test processed the 1.3GB file using 113kb of memory!!!).

[FLOWPLAYER=http://cdn.saiweb.co.uk/uploads/2009/09/sysadmin-iconv.mp4,487,417]

Also I have now added BOM (Byte order mark) detection:

[FLOWPLAYER=http://cdn.saiweb.co.uk/uploads/2009/09/sysadmin_oconv_bom.mp4,515,473]
