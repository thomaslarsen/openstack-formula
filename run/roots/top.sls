base:
    '*':
        - common
    'stack':
        - openstack.ntp.master
        - mysql.mariadb
        - mysql.python
        - mongodb
        - rabbitmq
        - openstack.keystone
        - openstack.keystone.service
        - openstack.keystone.identities
        - openstack.glance
        - openstack.nova.controller
        - openstack.nova.compute
        - openstack.neutron.controller
        - openstack.neutron.compute
    'controller':
        - openstack.ntp.master
        - mysql.mariadb
        - mysql.python
        - mongodb
        - rabbitmq
        - openstack.keystone
        - openstack.keystone.service
        - openstack.glance
        - openstack.nova.controller
        - openstack.neutron.controller
    'compute*':
        - openstack.nova.compute
        - openstack.neutron.compute