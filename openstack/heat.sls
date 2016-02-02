{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    
heat packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.heat }}
    
{% for sub, element in openstack_settings.config.heat.items() %}
{% for file, conf in element.files.items() %}
{{ sub }}-{{ file }}:
  file.managed:
    - name: {{ openstack_settings.config_base }}/{{ element.path }}/{{ file }}
    - source: salt://openstack/files/conf.jinja
    - template: jinja
    - makedirs: True
    - context:
        component: heat
        conf: {{ openstack_settings[conf] }}
        title: {{ sub }}
        settings: {{ openstack_settings }}
{% endfor %}
{% endfor %}
        
heat database:
  cmd.run:
    - name: heat-manage db_sync
    - user: heat
    - require:
      - sls: mysql.server
      - file: heat-heat.conf
    - unless: mysql -s -N -u heat --password={{ openstack_settings.passwords["heat"|upper + "_DBPASS"] }} -D heat -h {{ openstack_settings.hosts.database }} -e "select count(*) from {{ openstack_settings.db_table_test.heat }};"
    
{% if openstack_settings.services.heat is defined %}
{% for service in openstack_settings.services.heat %}
{{ service }}:
  service.running:
    - enable: True
    - require:
      - pkg: heat packages
      - cmd: heat database
    - watch:
      - file: heat-heat.conf
{% endfor %}
{% endif %}