{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    - openstack.cinder
    
cinder_controller packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.cinder_controller }}
    
cinder_controller database:
  cmd.run:
    - name: cinder-manage db sync
    - user: cinder
    - require:
      - sls: mysql.server
      - file: cinder-cinder.conf
    - unless: mysql -s -N -u cinder --password={{ openstack_settings.passwords["cinder"|upper + "_DBPASS"] }} -D cinder -h {{ openstack_settings.hosts.database }} -e "select count(*) from {{ openstack_settings.db_table_test.cinder_controller }};"
    
{% if openstack_settings.services.cinder_controller is defined %}
{% for service in openstack_settings.services.cinder_controller %}
cinder_controller-{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: True
    - require:
      - pkg: cinder_controller packages
      - cmd: cinder_controller database
    - watch:
      - file: cinder-cinder.conf
{% endfor %}
{% endif %}