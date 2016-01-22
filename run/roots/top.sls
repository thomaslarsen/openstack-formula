base:
    '*':
        - common
    'stack':
        - openstack.ntp.master
        - mysql.mariadb
        - mysql.python
        - mongodb
        - rabbitmq
        - openstack.horizon
        - openstack.keystone
        - openstack.keystone.service
        - openstack.keystone.identities
        - openstack.glance
        - openstack.nova.controller
        - openstack.nova.compute
        - openstack.neutron.controller
        - openstack.neutron.compute
        - openstack.cinder.controller
        - openstack.cinder.storage
        - openstack.cinder.loopback
    'controller':
        - openstack.ntp.master
        - mysql.mariadb
        - mysql.python
        - mongodb
        - rabbitmq
        - openstack.horizon
        - openstack.keystone
        - openstack.keystone.service
        - openstack.glance
        - openstack.nova.controller
        - openstack.neutron.controller
        - openstack.cinder.controller
    'compute*':
        - openstack.nova.compute
        - openstack.neutron.compute
    'storage*':
        - openstack.cinder.storage