{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack.neutron

{% set admin_url = "http://" + openstack_settings.hosts.keystone + ":" + openstack_settings.keystone_admin_port + "/v" + openstack_settings.keystone_api_version %}

{% for name, network in openstack_settings.networks.items() %}
create network {{ name }}:
  cmd.run:
    - name: neutron net-create {{ name }} {% if network.shared is defined %}--shared{% endif %} {% if network.provider is defined %}--provider:physical_network {{ network.provider.physical_network }} --provider:network_type {{ network.provider.network_type }}{% endif %} {% if network.external is defined %}--router:external{% endif %}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
      - OS_USERNAME: admin
      - OS_PASSWORD: {{ openstack_settings.passwords.ADMIN_PASS }}
      - require:
      - cmd: neutron_controller database
    - unless: neutron net-show {{ name }}
    
{% for sub_name, subnet in network.subnet.items() %}
create subnet {{ sub_name }}:
  cmd.run:
    - name: neutron subnet-create {{ name }} {{subnet.ip }} --name {{ sub_name }} --dns-nameserver {{ subnet.dns }} --gateway {{ subnet.gateway }} {% if subnet.dhcp is defined %}--enable_dhcp=True --allocation-pool start={{ subnet.dhcp.start }},end={{ subnet.dhcp.end }} {% else %}--enable_dhcp=False {% endif %}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
      - OS_USERNAME: admin
      - OS_PASSWORD: {{ openstack_settings.passwords.ADMIN_PASS }}
    - require:
      - cmd: neutron_controller database
      - cmd: create network {{ name }}
    - unless: neutron subnet-show {{ sub_name }}
    
{% endfor %}
{% endfor %}

{% for name, router in openstack_settings.routers.items() %}
create router {{ name }}:
  cmd.run:
    - name: neutron router-create {{ name }}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
      - OS_USERNAME: admin
      - OS_PASSWORD: {{ openstack_settings.passwords.ADMIN_PASS }}
      - require:
      - cmd: neutron_controller database
    - unless: neutron router-show {{ name }}
    
{% if router.gateway is defined %}
set gateway {{ router.gateway }} for router {{ name }}:
  cmd.run:
    - name: neutron router-gateway-set {{ name }} {{ router.gateway }}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
      - OS_USERNAME: admin
      - OS_PASSWORD: {{ openstack_settings.passwords.ADMIN_PASS }}
      - require:
      - cmd: neutron_controller database
      - cmd: create router {{ name }}
      - cmd: create network {{ router.gateway }}
    - unless: neutron gateway-device-show {{ name }}
{% endif %}
    
{% if router.interface is defined %}
{% for net_name in router.interface %}
add interface {{ net_name }} to router {{ name }}:
  cmd.run:
    - name: neutron router-interface-add {{ name }} {{ net_name }}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
      - OS_USERNAME: admin
      - OS_PASSWORD: {{ openstack_settings.passwords.ADMIN_PASS }}
      - require:
      - cmd: neutron_controller database
      - cmd: create subnet {{ net_name }}
    - unless: neutron router-port-list {{ name }} {{ net_name }}
{% endfor %}
{% endif %}
{% endfor %}
