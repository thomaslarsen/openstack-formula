{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    
glance packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.glance }}
      
{% for sub, element in openstack_settings.config.glance.items() %}
{% for file, conf in element.files.items() %}
{{ sub }}-{{ file }}:
  file.managed:
    - name: {{ openstack_settings.config_base }}/{{ element.path }}/{{ file }}
    - source: salt://openstack/files/conf.jinja
    - template: jinja
    - makedirs: True
    - context:
        component: glance
        conf: {{ openstack_settings[conf] }}
        title: {{ sub }}
        settings: {{ openstack_settings }}
{% endfor %}
{% endfor %}

glance database:
  cmd.run:
    - name: glance-manage db_sync
    - user: glance
    - require:
      - sls: mysql.server
      - file: glance-glance-api.conf
    - unless: mysql -s -N -u glance --password={{ openstack_settings.passwords["glance"|upper + "_DBPASS"] }} -D glance -h {{ openstack_settings.hosts.database }} -e "select count(*) from images;"
    
{% for service in openstack_settings.services.glance %}
{{ service }}:
  service.running:
    - enable: True
    - require:
      - cmd: glance database
    - watch:
      - file: glance-glance-api.conf
{% endfor %}