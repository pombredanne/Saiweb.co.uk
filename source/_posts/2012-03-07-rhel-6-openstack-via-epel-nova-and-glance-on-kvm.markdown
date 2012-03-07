---
layout: post
title: "RHEL 6 Openstack via EPEL Nova and Glance on KVM"
date: 2012-03-07 16:59
comments: true
published: true
categories:
- openstack 
---

In this post I will cover getting openstack nova and glance services installed from EPEL and configured to the point where an image can be started.
I will also be carrying out mySQL configuration of glance and nova, for 2011.3 (Diablo), though most if not all of this should be portable to the Essex release

<strong>Install EPEL</strong>

{% highlight bash %}
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm
{% endhighlight %}

<strong>Install Nova and Glance</strong>

{% highlight bash %}
yum -y install openstack-nova openstack-glance
{% endhighlight %}

yum should take care of all the dependencies here, and install both with a minimal configuration.

<strong>Burning and Rebuilding bridges</strong>

First thing's first KVM is going to install with it's own default bridged networking, this provides NAT.

Which is also noted as being <a href="http://www.cyberciti.biz/faq/linux-kvm-disable-virbr0-nat-interface/">very slow</a> (There is/was an note on the wiki@ linux-kvm.org but I have been unable to locate it at the time of writing)

If you are only setting this up for experimentation you can run with the default networking, simply use vibr0 in your nova.conf instead of br0.

<u> Burning Bridges </u>
{% highlight bash %}
virsh net-list
Name                 State      Autostart
-----------------------------------------
default              active     yes 
virsh net-destroy default
Network default destroyed
virsh net-undefine default
Network default has been undefined
service libvirtd restart
{% endhighlight %}

<u> Building Bridges </u>

The theory here is that this configuration of bridge will give us near native network performance, which if you are setting up for use beyond a throwaway sandbox, you really do not want to start introducing bottlenecks.

Shutdown and disable NetworkManager

{% highlight bash %}
service NetworkManager stop
chkconfig NetworkManager off
chkconfig network on
{% endhighlight %}

If you know of a NetworkManager friendly way of doing the following please let me know!

In this scenario br0 becomes your current eth0 

/etc/sysconfig/network-scripts/ifcfg-br0 
```
DEVICE=br0
TYPE=Bridge
BOOTPROTO=static
IPADDR=10.0.0.1
NETMASK=255.255.255.0
GATEWAY=10.0.0.254
ONBOOT=yes
DELAY=0
```

/etc/sysconfig/network-scripts/ifcfg-eth0
```
DEVICE=eth0
BOOTPROTO=none
TYPE=Ethernet
HWADDR=3c:4a:92:77:b3:9d
ONBOOT=yes
USERCTL=no
BRIDGE=br0
```

There is plenty more fun to be had here such as bonded interfaces (I myself have a few systems with bonded interfaces as such becoming br0 -> bond0 -> NIC's), but that's for another time.

Note: you may also use brctl for temporary configurations if you are just experimenting.
Caution: my network dropped out immediatly on my testbox, most likely because networkmanager was running, always ensure you can attach to the head of your box when doing network configuration ;-)

Once you have these configurations in place (Ensuring your have replaced the placeholder IP's and MAC address with valid ones) you can now go for a 

```
service network restart
```

All being well you'll lose and re-establish connection, of you'll be attaching a monitor / to kvm over ip.

<strong>Configuring Nova</strong>

First we're going to need a blank database, please ensure you change the placeholder password that follows for something more secure, and amend the host if you are using mySQL on the same host as nova.

{% highlight sql %}
create database nova;
grant all privileges on nova.* to 'nova'@'localhost' identified by 'nova';
{% endhighlight %}

Your /etc/nova.conf should resemble this:

```
--logdir=/var/log/nova
--state_path=/var/lib/nova
--lock_path=/var/lib/nova/tmp
--dhcpbridge=/usr/bin/nova-dhcpbridge
--dhcpbridge_flagfile=/etc/nova/nova.conf
--injected_network_template=/usr/share/nova/interfaces.template
--libvirt_xml_template=/usr/share/nova/libvirt.xml.template
--vpn_client_template=/usr/share/nova/client.ovpn.template
--credentials_template=/usr/share/nova/novarc.template
--network_manager=nova.network.manager.FlatDHCPManager
--iscsi_helper=tgtadm
--sql_connection=mysql://nova:nova@localhost/nova
--rabbit_host=localhost
--glance_api_servers=localhost:9292
--iscsi_ip_prefix=192.168.99.1
--bridge=br0
```

Setup the database and start the relevant nova services

{% highlight bash %}
nova-manage db sync
for i in api network scheduler compute; do service openstack-nova-$i start; done
for i in api network scheduler compute; do chkconfig openstack-nova-$i on; done
{% endhighlight %}

Note: you could also use openstack-nova-db-setup instead of "nova-manage db sync", _but_ it requires mysql-server, which at the time of writing if you have Percona installed will falsely adivse you a need t install mysql-server, Percona need to add: "Provides: mysql-server" to their spec ideally.

Remember this is only a basic setup so a lot of the options are left default such as the network_manager, I will cover their options at a later date.

Onto setting up a basic user (Note: this will be replaced in future posts with keystone)

{% highlight bash %}
nova-manage user admin saiweb
nova-manage project create saiweb saiweb
nova-manage network create saiweb 10.0.0.0/24 1 256 --bridge=br0
{% endhighlight %}



<strong> Configuring Glance </strong>


