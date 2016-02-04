{% from "openstack/map.jinja" import openstack_settings with context %}

include:
  - openstack.neutron
    
neutron_network packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.neutron_network.common }}
    - require:
      - pkg: openstack dependencies
        
{% if openstack_settings.services.neutron_network.common is defined %}
{% for service in openstack_settings.services.neutron_network.common %}
neutron_network-{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: True
    - require:
      - pkg: neutron_network packages
    - watch:
      - file: neutron-neutron.conf
{% endfor %}
{% endif %}