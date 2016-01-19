{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    
nova config:
  file.recurse:
    - name: /etc/nova
    - source: salt://openstack/files/etc/nova
    - makedirs: True
    - template: jinja
    - context:
        settings: {{ openstack_settings }}
        