{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    - openstack.nova
    
nova_controller packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.nova_controller }}
    
nova_controller database:
  cmd.run:
    - name: nova-manage db sync
    - user: nova
    - require:
      - sls: mysql.server
      - file: nova config
    - unless: mysql -s -N -u nova --password={{ openstack_settings.passwords["nova"|upper + "_DBPASS"] }} -D nova -h {{ openstack_settings.hosts.database }} -e "select count(*) from instances;"
    
{% for service in openstack_settings.services.nova_controller %}
{{ service }}:
  service.running:
    - enable: True
    - require:
      - cmd: nova_controller database
    - watch:
      - file: nova config
{% endfor %}