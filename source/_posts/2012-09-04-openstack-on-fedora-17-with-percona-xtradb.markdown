---
layout: post
title: "Openstack Essex, Nova, Glance, Keystone on Fedora 17 with Percona XtraDB"
date: 2012-09-04 17:26
comments: true
categories:
- linux
- openstack
- fedora
- percona 
---

As some of you may know I have been dabbling with [Pecona XtraDB Cluster](http://www.percona.com/software/percona-xtradb-cluster/), one concept I am working on
is having is as the back end mysql service for [Openstack](http://www.openstack.org).

What follows in this post is how to install [Pecona XtraDB Cluster](http://www.percona.com/software/percona-xtradb-cluster/), and use it with a complete openstack sessex deployment.

<h2>Assumptions</h2>

1. You are logging in as root. (if not remember sudo!)
2. You are setting up the percona installation (cluster configuration, credentials, etc..) seperate to this document and immediatly post install.
3. You do not allready have any databases or users named nova,glance or keystone in mysql.

<h2>Installing Percona XtraDB on Fedora 17</h2>

First we do is intstall percona-release: `rpm -Uvh http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm`

Second thing we need to do at the time of writing is work around the percona-release bug [#1045697](https://bugs.launchpad.net/percona-server/+bug/1045697) or face:

```
http://repo.percona.com/centos/17/os/x86_64/repodata/repomd.xml: [Errno 14] HTTP Error 404 - Not Found : http://repo.percona.com/centos/17/os/x86_64/repodata/repomd.xml
Trying other mirror.
Error: failure: repodata/repomd.xml from percona: [Errno 256] No more mirrors to try.
```

This is done simply by editing /etc/yum.repos.d/Percona.repo and replacing the line baseurl line with: http://repo.percona.com/centos/latest/os/$basearch/

<strong>NOTE:</strong> this will only be functional for Fedora 17+ and el6 (I have not tested f16 but that should also work, an earlier releases I can not say for certain, this change will also not work with el5)

Now we can proceed with installation

```
yum clean all
yum install Percona-XtraDB-Cluster-server
```

<h2>Installing Openstack</h2>

This next section adapts the guide [Getting started with Openstack on Fedora 17](http://fedoraproject.org/wiki/Getting_started_with_OpenStack_on_Fedora_17) wiki document; by this I mean that the provided configuration scripts i.e. openstack-db are written assuming an installation of mysql-server which are you will notice if you attempt to run them, will fail, as such whilst most steps are identical I am covering key points that allow for the use of Percona XtraDB.

This is not an issue with percona more the bash scripts are written with hard assumptions of using default mysql packages, which of course we are not doing :)

```
yum install --enablerepo=updates-testing openstack-utils openstack-nova openstack-glance openstack-keystone openstack-dashboard qpid-cpp-server-daemon
...
---> Package MySQL-python.x86_64 0:1.2.3-5.fc17 will be installed
--> Processing Dependency: libmysqlclient.so.18(libmysqlclient_16)(64bit) for package: MySQL-python-1.2.3-5.fc17.x86_64
Package mysql-libs is obsoleted by Percona-Server-shared-compat, but obsoleting package does not provide for requirements
--> Finished Dependency Resolution
Error: Package: MySQL-python-1.2.3-5.fc17.x86_64 (updates)
           Requires: libmysqlclient.so.18(libmysqlclient_16)(64bit)
           Available: mysql-libs-5.5.23-1.fc17.x86_64 (fedora)
               libmysqlclient.so.18(libmysqlclient_16)(64bit)
           Available: mysql-libs-5.5.27-1.fc17.x86_64 (updates)
               libmysqlclient.so.18(libmysqlclient_16)(64bit)
 You could try using --skip-broken to work around the problem
 You could try running: rpm -Va --nofiles --nodigest
```

<h3>BLAM!</h3>

Don't panic! this appears to be due to a missing "Provides:" declaration in the Percona-XtraDB-Cluster-server rpm package as I have noted in bug [#1045763](https://bugs.launchpad.net/percona-server/+bug/1045763)

To work around this take note of the MySQL-python version in question and find that package on [koji](http://koji.fedoraproject.org/) and install via --nodeps i.e.

```
rpm -Uvh --nodeps http://kojipkgs.fedoraproject.org//packages/MySQL-python/1.2.3/5.fc17/x86_64/MySQL-python-1.2.3-5.fc17.x86_64.rpm
Retrieving http://kojipkgs.fedoraproject.org//packages/MySQL-python/1.2.3/5.fc17/x86_64/MySQL-python-1.2.3-5.fc17.x86_64.rpm
Preparing... ########################################### [100%]
   1:MySQL-python ########################################### [100%]
yum install --enablerepo=updates-testing openstack-utils openstack-nova openstack-glance openstack-keystone openstack-dashboard qpid-cpp-server-daemon
```

<h4>Caveats</h4>

1. Future MySQL-python updates will be problematic, however the hope is [#1045763](https://bugs.launchpad.net/percona-server/+bug/1045763) will be fixed before it becomes an issue.

<h2>Setting up Openstack Databases</h2>

I'm assuming before this setup you have configured the node in question to work within your XtraDB cluster configuration if it exists, and you have set relevant root credentials.

We need to now setup the relevant databases and configuraionts

<h3>Nova</h3>

{% highlight sql %}
create database nova;
grant all privileges on nova.* to "nova"@"localhost" identified by "your_nova_password";
{% endhighlight %}

Edit /etc/nova/nova.conf and modify the sql_connection line:
```
...
sql_connection = mysql://nova:your_nova_password@localhost/nova
..
```

Now we need to tell nova to setup the relevant tables:

```
nova-manage db sync
WARNING nova.utils [-] /usr/lib64/python2.7/site-packages/sqlalchemy/pool.py:683: SADeprecationWarning: The 'listeners' argument to Pool (and create_engine()) is deprecated.  Use event.listen().
  Pool.__init__(self, creator, **kw)

WARNING nova.utils [-] /usr/lib64/python2.7/site-packages/sqlalchemy/pool.py:159: SADeprecationWarning: Pool.add_listener is deprecated.  Use event.listen()
  self.add_listener(l)

AUDIT nova.db.sqlalchemy.fix_dns_domains [-] Applying database fix for Essex dns_domains table.
```

The warnings for the moment can be safely ignored

<h3>Glance</h3>

{% highlight sql %}
create database glance;
grant all privileges on glance.* to "glance"@"localhost" identified by "your_glance_password";
{% endhighlight %}

Edit /etc/glance/glance-registry.conf and modify the sql_connection line:

```
...
sql_connection = mysql://glance:your_glance_password@localhost/glance
...
```
Now we need to tell glance to setup the relevant tables:

```
glance-manage db_sync
/usr/lib64/python2.7/site-packages/sqlalchemy/pool.py:683: SADeprecationWarning: The 'listeners' argument to Pool (and create_engine()) is deprecated.  Use event.listen().
  Pool.__init__(self, creator, **kw)
/usr/lib64/python2.7/site-packages/sqlalchemy/pool.py:159: SADeprecationWarning: Pool.add_listener is deprecated.  Use event.listen()
  self.add_listener(l)
```

Again warnings are for the moment at least safe to ignore.

<h3>Keystone</h3>

{% highlight sql %}
create database keystone;
grant all privileges on keystone.* to "keystone"@"localhost" identified by "your_keystone_password";
{% end highlight %}

Edit: /etc/keystone/keystone.cong and modify the connection line:

```
...
connection = mysql://keystone:your_keystone_password@localhost/keystone
...
```

Now we need to tell keystone to setup the relevant tables:

```
keystone-manage db_sync
```

<h2>Starting up services</h2>

Now we need to startup the relevant services

<h3>qpidd and libvirtd</h3>

```
systemctl start qpidd.service && sudo systemctl enable qpidd.service
qpidd.service is not a native service, redirecting to /sbin/chkconfig.
Executing /sbin/chkconfig qpidd on
systemctl start libvirtd.service && sudo systemctl enable libvirtd.service
```

<h3>Glance</h3>

{% highlight bash %}
for svc in api registry; do sudo systemctl start openstack-glance-$svc.service; done
for svc in api registry; do sudo systemctl enable openstack-glance-$svc.service; done
{% endhighlight %}

<h2>Keystone Setup</h2>

Setup a keystonerc file per the example at [Getting started with Openstack on Fedora 17](http://fedoraproject.org/wiki/Getting_started_with_OpenStack_on_Fedora_17)

{% highlight bash %}
cat > ~/.keystonerc <<EOF
export ADMIN_TOKEN=$(openssl rand -hex 10)
export OS_USERNAME=admin
export OS_PASSWORD=your_keystone_admin_password
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://127.0.0.1:5000/v2.0/
export SERVICE_ENDPOINT=http://127.0.0.1:35357/v2.0/
export SERVICE_TOKEN=$ADMIN_TOKEN
EOF
{% endhighlight %}

Add the loading of this information into your .bashrc:

{% highlight bash %}

{% endhighlight %}

And just to be on the paranoid side:

```
chmod 600 ~/.keystonerc
```

reload your ~/.bashrc and set the administrative token in the config file

```
source ~/.bashrc
openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_TOKEN
```

Start and enable keystone service:

```
systemctl start openstack-keystone.service && sudo systemctl enable openstack-keystone.service
```

I'm skipping over the creation of sample Tenants, Users and Roles please refer to  [Getting started with Openstack on Fedora 17](http://fedoraproject.org/wiki/Getting_started_with_OpenStack_on_Fedora_17) if you want to add them.

Configuring an admin user and tenancy:

I'm adapting the keystone setup I wrote about on my post: [RHEL 6 Openstack via EPEL Keystone Installation and Integration With Nova and Glance](http://blog.oneiroi.co.uk/openstack/rhel-6-openstack-via-epel-keystone-installation-and-integration-with-nova-and-glance/).


```
keystone tenant-create --name adminTenant
+-------------+----------------------------------+
|   Property  |              Value               |
+-------------+----------------------------------+
| description | None                             |
| enabled     | True                             |
| id          | ******************************** |
| name        | adminTenant                      |
+-------------+----------------------------------+

keystone user-create  --name admin \
                      --tenant_id  ******************************** \
                      --pass="$OS_PASSWORD" \
                      --email=you@yourdomain.com

```

<h3>Configure Nova to use Keystone</h3>

Apply configurations.

```
openstack-config --set /etc/nova/api-paste.ini filter:authtoken admin_tenant_name adminTenant
openstack-config --set /etc/nova/api-paste.ini filter:authtoken admin_user admin
openstack-config --set /etc/nova/api-paste.ini filter:authtoken admin_password $OS_PASSWORD
openstack-config --set /etc/nova/nova.conf DEFAULT auth_strategy keystone
```

And restart nova.

```
for svc in api compute; do sudo systemctl restart openstack-nova-$svc.service; done
```

>>> NEED TO ADD KEYSTONE ENDPOINTS NOW !!!! <<<
