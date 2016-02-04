{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack.neutron

# Install Neutron drivers

{% set driver_config_files = [] %}
{% set driver_packages = [] %}

{% for driver in openstack_settings.neutron_drivers %}
{% do driver_packages.extend(openstack_settings.dependencies.neutron_controller.drivers[driver]) %}

{% set element = openstack_settings.config.neutron_drivers[driver] %}
{% for file, conf in element.files.items() %}
{% if openstack_settings[conf] is defined %}
{% do driver_config_files.append('neutron-' + driver + '-' + file) %}
neutron-{{ driver }}-{{ file }}:
  file.managed:
    - name: {{ openstack_settings.config_base }}/{{ element.path }}/{{ file }}
    - source: salt://openstack/files/conf.jinja
    - template: jinja
    - makedirs: True
    - context:
        component: neutron driver
        conf: {{ openstack_settings[conf] }}
        title: {{ driver }}
        settings: {{ openstack_settings }}
{% endif %}
{% endfor %}
{% endfor %}

neutron_driver packages:
  pkg.installed:
    - pkgs: {{ driver_packages }}
    - require:
      - pkg: openstack dependencies


# Install Neutron itself

neutron_controller packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.neutron_controller.common }}
    - require:
      - pkg: openstack dependencies
    
neutron_controller database:
  cmd.run:
    - name: neutron-db-manage --config-file {{ openstack_settings.config_base }}/neutron/neutron.conf --config-file {{ openstack_settings.config_base }}/neutron/plugins/ml2/ml2_conf.ini upgrade head
    - user: neutron
    - require:
      - sls: mysql.server
      - file: neutron-neutron.conf
      - file: ml2-ml2_conf.ini
    - unless: mysql -s -N -u neutron --password={{ openstack_settings.passwords["neutron"|upper + "_DBPASS"] }} -D neutron -h {{ openstack_settings.hosts.database }} -e "select count(*) from {{ openstack_settings.db_table_test.neutron_controller }};"
    
{% if openstack_settings.services.neutron_controller.common is defined %}
{% for service in openstack_settings.services.neutron_controller.common %}
neutron_controller-{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: True
    - require:
      - pkg: neutron_controller packages
      - pkg: neutron_driver packages
      - cmd: neutron_controller database
    - watch:
      - file: neutron-neutron.conf
{% for config_file in driver_config_files %}
      - file: {{ config_file }}
{% endfor %}
{% endfor %}
{% endif %}

