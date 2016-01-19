{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    - openstack.nova
    
nova_compute packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.nova_compute }}
    
{% for service in openstack_settings.services.nova_compute %}
{{ service }}:
  service.running:
    - enable: True
    - require:
      - pkg: nova_compute packages
    - watch:
      - file: nova config
{% endfor %}