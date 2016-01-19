{% from "openstack/map.jinja" import openstack_settings with context %}

{% set admin_url = "http://" + openstack_settings.hosts.keystone + ":" + openstack_settings.keystone_admin_port + "/v" + openstack_settings.keystone_api_version %}

include:
  - openstack.keystone
  
{% for name, service in openstack_settings.service.items() %}
create service {{ name }}:
  cmd.run:
    - name: openstack service create --name {{ name }} --description '{{ service.description }}' {{ service.type }}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
    - require:
      - cmd: keystone database
    - unless: openstack service show {{ name }}
    
{% for interface, endpoint in service.endpoint.items() %}
create service {{ name }} endpoint {{ interface }}:
  cmd.wait:
    - name: 'openstack endpoint create --region {{ endpoint.region }} {{ service.type }} {{ interface }} {{ endpoint.url }}'
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
    - watch:
      - cmd: create service {{ name }}
{% endfor %}
{% endfor %}