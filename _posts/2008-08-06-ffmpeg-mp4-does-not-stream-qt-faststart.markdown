--- 
layout: post
title: ffmpeg MP4 does not stream qt-faststart
tags: 
- ffmpeg
- qt-faststart
date: "2008-08-06"
---
ffmpeg comes with a tool to re-order the MP4 "atoms" (Seriously don't ask  what are MP4 atoms it's geek for the sake of geek).

find the file in ffmpeg_src/tools/qt-faststart.c

compile with gcc

<code>
gcc qt-faststart.c -o qt-faststart
</code>

And run.

<code>
/path/to/qt-faststart /path/to/src_vid.mp4 /path/to/output.mp4
</code>

NOTE: This only seems to work for h264 encoded videos (libx264).
