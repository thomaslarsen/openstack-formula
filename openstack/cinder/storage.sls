{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    - openstack.cinder
    
cinder_storage packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.cinder_storage }}
        
{% if openstack_settings.services.cinder_storage is defined %}
{% for service in openstack_settings.services.cinder_storage %}
cinder_storage-{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: True
    - require:
      - pkg: cinder_storage packages
    - watch:
      - file: cinder-cinder.conf
{% endfor %}
{% endif %}