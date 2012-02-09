--- 
layout: post
title: Linux - The Sysadmin Script - Part 4
tags: 
- linux
- sysadmin
---
In part 4, I am going to cover more of an improvement than anything else to <a href="http://www.saiweb.co.uk/linux/linux-the-sysadmin-script-part-3">part 3</a>

Part 3 itself is not incorrect, it correctly takes a memory footprint for each process running, the same as VIRT in top ...

However in processes such as APACHE the VIRT memory is the size of all shared libraries, as correctly shown by pmap ...

So what does this mean realy?

The memory usage is infact the following VIRT + RSS, where RSS is the resident set size, the RSS is a representation of the memory in use by the PID, and VIRT is shared between the child processes.

<code>
[buzz@buzz_srv ~]# ps aux | grep httpd | grep -v 'grep'
root     16378  0.0  0.1 148640  3024 ?        Ss   Nov13   0:00 /usr/sbin/httpd
apache   20088  0.0  0.1 148640  3304 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20101  0.0  0.1 148640  3304 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20756  0.0  0.1 148640  3312 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20759  0.0  0.1 148640  3300 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20790  0.0  0.1 148640  3284 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20792  0.0  0.1 148640  3312 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20798  0.0  0.1 148640  3308 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20804  0.0  0.1 148640  3308 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20886  0.0  0.1 148640  3304 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20906  0.0  0.1 148640  3300 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20907  0.0  0.1 148640  3308 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20912  0.0  0.1 148640  3304 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20915  0.0  0.1 148640  3312 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20959  0.0  0.1 148640  3304 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20969  0.0  0.1 148640  3300 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20994  0.0  0.1 148640  3320 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20995  0.0  0.1 148640  3288 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20996  0.0  0.1 148640  3320 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20997  0.0  0.1 148640  3320 ?        S    Nov13   0:00 /usr/sbin/httpd
apache   20999  0.0  0.1 148640  3296 ?        S    Nov13   0:00 /usr/sbin/httpd
</code>

As can be seen above the 'VIRT' does not change between the child processes, where as the RSS does dependant on what the thread is doing at that time.

So below is an improved appmem function to allow for this:


<code lang="bash" line="1">
function appmem {
        if [ -z "$1" ]; then
                echo "Usage: sysadmin appmem app_name i.e. (sysadmin appmem apache)";
        else
                RRES=(`ps aux | grep "$1" | grep -v 'grep' | grep -v "$0" | awk '{print $6}'`);
                VRES=(`ps aux | grep "$1" | grep -v 'grep' | grep -v "$0" | awk '{print $5}'`);
                COUNT=0;
                VMEM=0;
                RMEM=0;
                for RSS in ${RRES[@]}
                do
                        RMEM=$(($RSS+$RMEM));
                done;
                for VIRT in ${VRES[@]}
                do
                        VMEM=$(($VIRT+$VMEM));
                        COUNT=$(($COUNT+1));
                done;
                VMEM=$(($VMEM/$COUNT));
                VMEM=$(($VMEM/1024));
                RMEM=$(($RMEM/1024));
                echo -e "$YELLOW ----- MEMORY USAGE REPORT FOR '$1' ----- $CLEAR";
                echo "PID Count: $COUNT";
                echo "Shared Mem usage: $VMEM MB";
                echo "Total Resident Set Size: $RMEM MB";
                echo "Mem/PID: $(($RMEM/$COUNT)) MB";
        fi
}
</code>

Example output:

<code>
 ----- MEMORY USAGE REPORT FOR 'httpd' ----- 
PID Count: 41
Shared Mem usage: 140 MB
Total Resident Set Site: 95 MB
Mem/PID: 2 MB
</code>
