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
    'controller':
        - openstack.ntp.master
        - mysql.mariadb
        - mysql.python
        - mongodb
        - rabbitmq
        - openstack.keystone
        - openstack.keystone.service
        - openstack.glance
    'compute*':
        - openstack.nova.compute