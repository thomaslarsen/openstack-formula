{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack.neutron
    
neutron_compute packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.neutron_compute.common }}
    - require:
      - pkg: openstack dependencies
    
{% if openstack_settings.services.neutron_compute.common is defined %}
{% for service in openstack_settings.services.neutron_compute.common %}
neutron_compute-{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: True
    - require:
      - pkg: neutron_compute packages
    - watch:
      - file: neutron-neutron.conf
{% endfor %}
{% endif %}