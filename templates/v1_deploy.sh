#!/bin/bash
time openstack overcloud deploy --templates /home/stack/osp16/openstack-tripleo-heat-templates/ \
-n /home/stack/osp16/openstack-tripleo-heat-templates/network_data.yaml \
-r /home/stack/osp16/openstack-tripleo-heat-templates/roles_data.yaml \
-e /home/stack/containers-prepare-parameter.yaml \
-e /home/stack/osp16/openstack-tripleo-heat-templates/environments/network-environment.yaml \
-e /home/stack/osp16/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
-e /home/stack/osp16/openstack-tripleo-heat-templates/scheduler_hints_env.yaml \
-e /home/stack/osp16/openstack-tripleo-heat-templates/node-info.yaml \
-e /home/stack/osp16/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml \
--libvirt-type qemu \
--timeout 180
