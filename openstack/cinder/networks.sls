{% from "openstack/map.jinja" import openstack_settings with context %}

{% set admin_url = "http://" + openstack_settings.hosts.keystone + ":" + openstack_settings.keystone_admin_port + "/v" + openstack_settings.keystone_api_version %}

include:
  - openstack.cinder

{% for name, network in openstack_settings.networks.items() %}
create network {{ name }}:
  cmd.run:
    - name: neutron net-create {{ name }} \
        {% if network.share is defined %}--shared{% endif %} \
        --provider:physical_network {{ network.provider.pysical_network }} \
        --provider:network_type {{ network.provider.network_type }}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
    - require:
      - cmd: neutron_controller database
    - unless: neutron net-show {{ name }}
{% endfor %}


