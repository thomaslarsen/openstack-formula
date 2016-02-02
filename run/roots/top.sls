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
        - openstack.neutron.network
        - openstack.neutron.setup
        - openstack.neutron.agents.controller
        - openstack.neutron.agents.compute
        - openstack.neutron.agents.network
        - openstack.cinder.controller
        - openstack.cinder.storage
        - openstack.cinder.loopback
        - openstack.heat
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
        - openstack.neutron.agents.controller
        - openstack.cinder.controller
        - openstack.heat
    'compute*':
        - openstack.nova.compute
        - openstack.neutron.compute
        - openstack.neutron.agents.compute
    'storage*':
        - openstack.cinder.storage
    'network*':
        - openstack.neutron.network
        - openstack.neutron.agents.network