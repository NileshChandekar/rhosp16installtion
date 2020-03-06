# RHOSP-16

![Image ipa](https://github.com/NileshChandekar/rhosp16installtion/blob/master/images/16_1.png)

~~~
prov - swp11-20     eth0 nic1 ens3
ext  - swp1-2-10	eth1 nic2 ens4
vlan - swp21-28     eth2 nic3 ens5
~~~



## Router Configuration:

* Interface Configuration :-

~~~
set interfaces ethernet eth0 address 'dhcp'
set interfaces ethernet eth0 description 'OUTSIDE'
set interfaces ethernet eth1 address '192.168.100.1/24'
set interfaces ethernet eth1 description 'INSIDE'
~~~

* SSH Configure:

~~~
set service ssh port '22'
~~~

* Ethernet Speed Configuration

~~~
set interfaces ethernet eth1 duplex 'auto'
~~~

### Configure Source NAT for our "Inside" network.

~~~
set nat source rule 10 outbound-interface 'eth0'
set nat source rule 10 protocol 'all'
set nat source rule 10 source address '192.168.100.0/24'
set nat source rule 10 translation address 'masquerade'
~~~

### Configure DNS forwarder:

~~~
set service dns forwarding cache-size '0'
set service dns forwarding listen-on 'eth1'
set service dns forwarding name-server '192.168.100.1'
set service dns forwarding name-server '8.8.8.8'
~~~

## Cumulus

~~~
auto br-ex
iface br-ex
    bridge-ports swp1 swp2 swp3 swp4 swp5 swp6 swp7 swp8 swp9 swp10
    bridge-vlan-aware no
    bridge-pvid 1
    bridge-stp off

auto br-prov
iface br-prov
    bridge-ports swp11 swp12 swp13 swp14 swp15 swp16 swp17 swp18 swp19 swp20
    bridge-vlan-aware no
    bridge-pvid 1
    bridge-stp off

auto br-vlan
iface br-vlan
    bridge-ports swp21 swp22 swp23 swp24 swp25 swp26 swp27 swp28
    bridge-pvid 1
    bridge-vids 710-750
    bridge-vlan-aware yes
    bridge-s
~~~




## Undercloud Node

subscription-manager register  --username <username> --password <password>


----------


#!/bin/bash

echo rhel-8-for-x86_64-baseos-rpms > test.txt
echo rhel-8-for-x86_64-appstream-rpms >> test.txt
echo rhel-8-for-x86_64-highavailability-rpms >> test.txt
echo ansible-2.8-for-rhel-8-x86_64-rpms >> test.txt
echo satellite-tools-6.5-for-rhel-8-x86_64-rpms >> test.txt
echo openstack-16-for-rhel-8-x86_64-rpms >> test.txt
echo fast-datapath-for-rhel-8-x86_64-rpms >> test.txt


subscription-manager repos --disable=*

for i in $(cat test.txt) ; do subscription-manager repos --enable=$i ; done

yum install wget git tmux -y
yum update -y
yum upgrade -y


hostnamectl set-hostname manager16.example.com
hostnamectl set-hostname --transient manager16.example.com
echo "127.0.0.1 manager16.example.com manager16" > /etc/hosts


useradd stack
echo stack | passwd --stdin stack
echo "stack ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/stack
chmod 0440 /etc/sudoers.d/stack

cp /root/3.sh /home/stack/

su stack -c "sh /home/stack/3.sh"
su - stack

sudo yum install -y python3-tripleoclient

openstack tripleo container image prepare default --local-push-destination --output-env-file containers-prepare-parameter.yaml

sudo reboot




  ContainerImageRegistryCredentials:
    registry.redhat.io:
      1979710|nchandek: eyJhbGciOiJSUzUxMiJ9.eyJzdWIiOiIwZTEzYjI1OTdmM2U0M2IxYTAwNGJkNDU3ZTNiN2ZlZSJ9.PDbFOKDfLUTVJGIv4Bc-yYiWoMtJsZGk_VLdzvDKCFhDY2PPKL7IUAS_bpbtg-457kk726QDp6jGjOVjEfp9s-Vn9EwI-9IYC5ZSXuIMEQZIVZ15Pl5LZoKh88rf_K8D2bI_KQqpfSs9sccxl0H0a-uJq_IzAKU_cJWiCRBnWcQw-sRaWKV70olqgdRq_QuVPv_YWoOeeeYMfRLBQKE92y0GxMoZ8DZxLyhvtPjqN97QrKv-bY0X9XQpA-WXLo9KXWngqRbtaJKV-Lt1ZPYHWH3a_b1AkU1thKL-mzbecKUuX2ukHapj9PT2zxZAfXPV3NyrTn93jv3CRlq3rRqjpW6smn2N54n9S_FmnX3sb7ZcGDsRlYvw7RENBDm2DkkZLgsTdRj0R8PtFeC2dgNAjqJJFKj4eBq0mhfQCsjnKFRApU7XdT4aRf3MqlIhYpUBQmz0FPeGB5jDbCewpYcYGcShHX1KxbDEwGC4S6-DsCklyvKOOHZd_36005j1oTPZC1rLXEm8rU4c8xNlE2MbpFqvkhLxFPyIhS4xaZ0PcvrwTs7Tv25ha-nU1O6qRLgDA2x4JlW0-XsQu_-kYlwkgUSPJlAMVRVWCNr2DWSJhBLjEJBLGIGoDsGpyzkmEXXTVo5MB_wzjf5KmrxsMtbA2gNURWG8klMhnFt2Kp4VloU


https://access.redhat.com/terms-based-registry/#/token/nchandek/info




sudo echo 'none' > /sys/block/sda/queue/scheduler
sudo cat /sys/block/sda/queue/scheduler




[stack@undercloud-0-osp16 ~]$ cat 2.sh

#!/bin/bash

echo -e "[DEFAULT]
local_interface = eth0
container_images_file = /home/stack/containers-prepare-parameter.yaml
local_ip = 192.168.24.1/24
undercloud_public_host = 192.168.24.2
undercloud_admin_host = 192.168.24.3
undercloud_ntp_servers=clock.redhat.com
[ctlplane-subnet]
local_subnet = ctlplane-subnet
cidr = 192.168.24.0/24
dhcp_start = 192.168.24.5
dhcp_end = 192.168.24.24
gateway = 192.168.24.1
inspection_iprange = 192.168.24.100,192.168.24.120
masquerade = true
#TODO(skatlapa): add param to override masq" > ~/undercloud.conf


openstack undercloud install

[stack@undercloud-0-osp16 ~]$


openstack undercloud install



The Undercloud has been successfully installed.

Useful files:

Password file is at ~/undercloud-passwords.conf
The stackrc file is at ~/stackrc

Use these files to interact with OpenStack services, and
ensure they are secured.

##########################################################

[stack@undercloud-0-osp16 ~]$



#!/bin/bash

sudo yum install libguestfs-tools -y
mkdir ~/images
mkdir ~/templates
cd  ~/images

source ~/stackrc
sudo yum install rhosp-director-images rhosp-director-images-ipa -y
for i in /usr/share/rhosp-director-images/ironic-python-agent-16.0-*.tar /usr/share/rhosp-director-images/overcloud-full-16*.tar ; do tar -xvf $i; done


openstack overcloud image upload --image-path /home/stack/images/

openstack image list

sudo sed -i '/enabled_hardware_types/s/$/,manual-management/' /var/lib/config-data/puppet-generated/ironic/etc/ironic/ironic.conf
sudo systemctl restart tripleo_ironic_api.service tripleo_ironic_conductor.service





vi /home/stack/instackenv.json

~~~
{
"nodes":[
{
"mac":["00:50:00:00:04:00"
],
"name":"controller-0",
"capabilities" : "node:ctrl-0,boot_option:local",
"pm_type":"fake_pxe"
},

{
"mac":["00:50:00:00:05:00"
],
"name":"compute-0",
"capabilities" : "node:cmpt-0,boot_option:local",
"pm_type":"fake_pxe"
}


]
}
~~~


# udp should be enough
iptables -I INPUT 1 -p udp --dport 123 -j ACCEPT
iptables -I OUTPUT 1 -p udp --sport 123 -j ACCEPT

# but also ok to add tcp
iptables -I INPUT 2 -p tcp --dport 123 -j ACCEPT
iptables -I OUTPUT 2 -p tcp --sport 123 -j ACCEPT


iptables-save
iptables -nvL | grep -i 123



openstack overcloud node import /home/stack/instackenv.json
openstack overcloud node introspect --all-manageable --provide

openstack overcloud node introspect --all-manageable --provide & ; ssh  root@dell-r530-62.gsslab.pnq2.redhat.com bash -x 16_start.sh

ssh root@dell-r530-62.gsslab.pnq2.redhat.com bash -x 16_stop.sh



openstack baremetal node list ; openstack overcloud profiles list

+--------------------------------------+--------------+---------------+-------------+--------------------+-------------+
| UUID                                 | Name         | Instance UUID | Power State | Provisioning State | Maintenance |
+--------------------------------------+--------------+---------------+-------------+--------------------+-------------+
| ad5b4600-7b62-4754-a9f3-054666b7ba84 | controller-0 | None          | power off   | available          | False       |
| 3ced2c22-bc71-4136-a97b-04e782ad974a | controller-1 | None          | power off   | available          | False       |
| 042f6433-095e-423e-8c1c-bebce876bf27 | controller-2 | None          | power off   | available          | False       |
| 4430880d-0ab8-4a5b-ba27-950ab142f80f | compute-0    | None          | power off   | available          | False       |
+--------------------------------------+--------------+---------------+-------------+--------------------+-------------+
+--------------------------------------+--------------+-----------------+-----------------+-------------------+
| Node UUID                            | Node Name    | Provision State | Current Profile | Possible Profiles |
+--------------------------------------+--------------+-----------------+-----------------+-------------------+
| ad5b4600-7b62-4754-a9f3-054666b7ba84 | controller-0 | available	| None            |                   |
| 3ced2c22-bc71-4136-a97b-04e782ad974a | controller-1 | available	| None            |                   |
| 042f6433-095e-423e-8c1c-bebce876bf27 | controller-2 | available	| None            |                   |
| 4430880d-0ab8-4a5b-ba27-950ab142f80f | compute-0    | available	| None            |                   |
+--------------------------------------+--------------+-----------------+-----------------+-------------------+






(undercloud) [stack@undercloud-0-osp16 ~]$ for i in $(openstack overcloud profiles list | awk {'print $2'} | awk 'NR > 2') ; do openstack baremetal node show $i -c properties ; done
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                           |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| properties | {'capabilities': 'boot_option:local,node:ctrl-0,cpu_hugepages:true', 'local_gb': '60', 'cpus': '4', 'cpu_arch': 'x86_64', 'memory_mb': '12000'} |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                           |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| properties | {'capabilities': 'boot_option:local,node:ctrl-1,cpu_hugepages:true', 'local_gb': '60', 'cpus': '4', 'cpu_arch': 'x86_64', 'memory_mb': '12000'} |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                           |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| properties | {'capabilities': 'boot_option:local,node:ctrl-2,cpu_hugepages:true', 'local_gb': '60', 'cpus': '4', 'cpu_arch': 'x86_64', 'memory_mb': '12000'} |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                           |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| properties | {'capabilities': 'boot_option:local,node:cmpt-0,cpu_hugepages:true', 'local_gb': '60', 'cpus': '4', 'cpu_arch': 'x86_64', 'memory_mb': '12000'} |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
(undercloud) [stack@undercloud-0-osp16 ~]$






1. Replicate the templates in /home/stack dir
$ cd /home/stack
$ cp -r /usr/share/openstack-tripleo-heat-templates/ .

2. Modify network_data.yaml

3. Render the template files
$ ./tools/process-templates.py -r roles_data.yaml -n network_data.yaml --safe

4. Create/Modify controller.yaml and compute.yaml in /home/stack/templates/openstack-tripleo-heat-templates/network/config (As per the scenario)

5. Make sure to include the proper controller.yaml and compute.yaml for deployment in /home/stack/templates/openstack-tripleo-heat-templates/environments/network-environment.yaml





#!/bin/bash
time openstack overcloud deploy --templates /home/stack/openstack-tripleo-heat-templates/ \
-n /home/stack/openstack-tripleo-heat-templates/network_data.yaml \
-r /home/stack/openstack-tripleo-heat-templates/roles_data.yaml \
-e /home/stack/containers-prepare-parameter.yaml \
-e /home/stack/openstack-tripleo-heat-templates/environments/network-environment.yaml \
-e /home/stack/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
-e /home/stack/openstack-tripleo-heat-templates/scheduler_hints_env.yaml \
-e /home/stack/openstack-tripleo-heat-templates/node-info.yaml \
-e /home/stack/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml \
--libvirt-type qemu



~~~
node-info.yaml
~~~

parameter_defaults:
  OvercloudControllerFlavor: baremetal
  OvercloudComputeFlavor: baremetal
  ControllerCount: 3
  ComputeCount: 2
  NtpServer: 192.168.24.10

parameter_defaults:
  ControllerSchedulerHints:
    'capabilities:node': 'control-%index%'
  ComputeSchedulerHints:
    'capabilities:node': 'compute-%index%'



* TO delete the stack:

~~~
openstack stack delete overcloud --yes --wait && openstack overcloud plan delete overcloud
~~~

~~~
for i in $(openstack baremetal node list | awk {'print $2'} | awk 'NR > 2') ; do openstack baremetal node delete $i ; done
~~~




####

Scaling the compute Node:

~~~
(undercloud) [stack@manager16 ~]$ cat instackenv.json
{
"nodes":[
{
"mac":["00:50:00:00:04:00"
],
"name":"controller-0",
"capabilities" : "node:ctrl-0,boot_option:local",
"pm_type":"fake_pxe"
},

{
"mac":["00:50:00:00:05:00"
],
"name":"compute-0",
"capabilities" : "node:cmpt-0,boot_option:local",
"pm_type":"fake_pxe"
},

{
"mac":["00:50:00:00:06:00"
],
"name":"compute-1",
"capabilities" : "node:cmpt-1,boot_option:local",
"pm_type":"fake_pxe"
}



]
}
(undercloud) [stack@manager16 ~]$
~~~

~~~
(undercloud) [stack@manager16 ~]$ openstack overcloud node import /home/stack/instackenv.json
~~~

~~~
+--------------------------------------+--------------+--------------------------------------+-------------+--------------------+-------------+
| UUID                                 | Name         | Instance UUID                        | Power State | Provisioning State | Maintenance |
+--------------------------------------+--------------+--------------------------------------+-------------+--------------------+-------------+
| 3c8e010e-8f73-4fbe-812f-8a09876cbf12 | controller-0 | 52d15732-7bd2-4b2d-8803-60ed8601d1f2 | power on    | active             | False       |
| 4f2d6e3c-51cc-475c-9055-9cc616e2da6c | compute-0    | e72dc7f4-5037-46a8-8ce9-60e46c3a772e | power on    | active             | False       |
| f2c08719-2c3c-4d3c-92a5-c321420c02bf | compute-1    | None                                 | None        | manageable         | False       |
+--------------------------------------+--------------+--------------------------------------+-------------+--------------------+-------------+
~~~

~~~
(undercloud) [stack@manager16 ~]$ openstack overcloud node introspect f2c08719-2c3c-4d3c-92a5-c321420c02bf --provide
~~~

# OUTCOME

~~~
(undercloud) [stack@manager16 ~]$ openstack overcloud node introspect f2c08719-2c3c-4d3c-92a5-c321420c02bf --provide
Waiting for introspection to finish...
Waiting for messages on queue 'tripleo' with no timeout.
Introspection of node f2c08719-2c3c-4d3c-92a5-c321420c02bf completed. Status:SUCCESS. Errors:None
Successfully introspected 1 node(s).
Waiting for messages on queue 'tripleo' with no timeout.
1 node(s) successfully moved to the "available" state.
(undercloud) [stack@manager16 ~]$
~~~

~~~
+--------------------------------------+--------------+--------------------------------------+-------------+--------------------+-------------+
| UUID                                 | Name         | Instance UUID                        | Power State | Provisioning State | Maintenance |
+--------------------------------------+--------------+--------------------------------------+-------------+--------------------+-------------+
| 3c8e010e-8f73-4fbe-812f-8a09876cbf12 | controller-0 | 52d15732-7bd2-4b2d-8803-60ed8601d1f2 | power on    | active             | False       |
| 4f2d6e3c-51cc-475c-9055-9cc616e2da6c | compute-0    | e72dc7f4-5037-46a8-8ce9-60e46c3a772e | power on    | active             | False       |
| f2c08719-2c3c-4d3c-92a5-c321420c02bf | compute-1    | None                                 | power off   | available          | False       |
+--------------------------------------+--------------+--------------------------------------+-------------+--------------------+-------------+
~~~

~~~
(undercloud) [stack@manager16 ~]$ openstack overcloud node configure f2c08719-2c3c-4d3c-92a5-c321420c02bf
Waiting for messages on queue 'tripleo' with no timeout.
Successfully configured the nodes.
(undercloud) [stack@manager16 ~]$
~~~

~~~
(undercloud) [stack@manager16 ~]$ openstack baremetal node show f2c08719-2c3c-4d3c-92a5-c321420c02bf -c properties
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                           |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| properties | {'capabilities': 'boot_option:local,cpu_hugepages:true,node:cmpt-1', 'local_gb': '60', 'cpus': '6', 'cpu_arch': 'x86_64', 'memory_mb': '12000'} |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
(undercloud) [stack@manager16 ~]$
~~~

~~~
parameter_defaults:
  OvercloudControllerFlavor: baremetal
  OvercloudComputeFlavor: baremetal
  ControllerCount: 1
  ComputeCount: 2 <===== increased from 1 - 2
  NtpServer: 192.168.24.1
~~~
