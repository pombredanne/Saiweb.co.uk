--- 
layout: post
title: Nagios - Send alerts to twitter
tags: 
- nagios
- sms
- text
- twitter
- alert
---
Pre-req reading:

<a href="http://www.saiweb.co.uk/nagios/nagios-customization-alerting-via-sms-or-anything-you-like">Nagios customization: Alerting via SMS, or anything you like!</a>

<a href="http://www.saiweb.co.uk/linux/update-twitter-in-a-single-line">Making the bird tweet using python
</a>
or
<a href="http://www.saiweb.co.uk/python/making-the-bird-tweet-using-python">Update twitter in a single line</a>

This entry will cover how to send nagios alerts to twitter, in the examples to follow curl will be used however you can choose to use the python example (link above) in place of this.

Firstly edit /usr/local/nagios/etc/objects/commands.cfg

And add the two following commands.

<strong>UPDATE 24/03/2011</strong> Twitter no longer supports basic auth, use my oAuth updater <a href="https://github.com/Oneiroi/nagios_addons/blob/master/twitter/nagios_bot.py">here</a>

[cc lang="bash"]
define command {
        command_name    notify-by-twitter
        command_line    /usr/bin/curl --basic --user "twitteruser:twitterpassword" --data-ascii "status=[Nagios] $NOTIFICATIONTYPE$ $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$" http://twitter.com/statuses/update.json
}

define command {
        command_name    host-notify-by-twitter
        command_line    /usr/bin/curl --basic --user "twitteruser:twitterpassword" --data-ascii "status=[Nagios] $HOSTSTATE$ alert for $HOSTNAME$" http://twitter.com/statuses/update.json
}
[/cc]

Now define a contact for this twitter service

/usr/local/nagios/etc/objects/contacts.cfg

[cc lang="bash"]
define contact{
        contact_name                    twitter
        service_notification_commands   notify-by-twitter
        host_notification_commands      host-notify-by-twitter
        service_notification_period 24x7
        host_notification_period 24x7
        service_notification_options a
        host_notification_options a
}
[/cc]

Choose your own notification options, for my feed I only choose alerts, I also have this send updated to a 'private feed' which I then follow.

Add this contact into your existing contact groups, i.e.


[cc lang="bash"]
define contactgroup{
        contactgroup_name       admins
        alias                   Nagios Administrators
        members                 nagiosadmin,sms_alert,twitter
        }
[/cc]

Then run a nagios-verify to ensure you have no syntax errors, and restart nagios.

Trigger an alert by manually switching a monitored service off or entering a manual result to test.

 
