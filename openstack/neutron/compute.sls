{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    - openstack.neutron
    
neutron_compute packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.neutron_compute }}
    
    
{% if openstack_settings.services.neutron_compute is defined %}
{% for service in openstack_settings.services.neutron_compute %}
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