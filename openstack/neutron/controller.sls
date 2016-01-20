{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    - openstack.neutron
    
neutron_controller packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.neutron_controller }}
    
neutron_controller database:
  cmd.run:
    - name: neutron-db-manage --config-file {{ openstack_settings.config_base }}/neutron/neutron.conf --config-file {{ openstack_settings.config_base }}/neutron/plugins/ml2/ml2_conf.ini upgrade head
    - user: neutron
    - require:
      - sls: mysql.server
      - file: neutron-neutron.conf
    - unless: mysql -s -N -u neutron --password={{ openstack_settings.passwords["neutron"|upper + "_DBPASS"] }} -D neutron -h {{ openstack_settings.hosts.database }} -e "select count(*) from {{ openstack_settings.db_table_test.neutron_controller }};"
    
{% if openstack_settings.services.neutron_controller is defined %}
{% for service in openstack_settings.services.neutron_controller %}
neutron_controller-{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: True
    - require:
      - pkg: neutron_controller packages
      - cmd: neutron_controller database
    - watch:
      - file: neutron-neutron.conf
{% endfor %}
{% endif %}