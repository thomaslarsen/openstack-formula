{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack.ntp

/etc/chrony.conf:
    file.managed:
        - name: /etc/chrony.conf
        - source: salt://openstack/files/chrony.conf
        - context:
            servers: {{ openstack_settings.ntp.servers }}
        
        