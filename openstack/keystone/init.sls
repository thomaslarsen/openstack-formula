{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    - apache.config
    - apache.vhosts.standard
    
{% from "apache/map.jinja" import apache with context %}

keystone packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.keystone }}
    - require:
      - pkg: openstack dependencies
    - watch_in:
      - service: apache
    
mod_wsgi:
  pkg.installed:
    - name: {{ apache.mod_wsgi }}
    - require:
      - pkg: apache
    - watch_in:
      - service: apache
      
memcached:
  service.running:
    - enable: True
    - require:
      - pkg: keystone packages

{% for sub, element in openstack_settings.config.keystone.items() %}
{% for file, conf in element.files.items() %}
{{ sub }}-{{ file }}:
  file.managed:
    - name: {{ openstack_settings.config_base }}/{{ element.path }}/{{ file }}
    - source: salt://openstack/files/conf.jinja
    - template: jinja
    - makedirs: True
    - context:
        component: keystone
        conf: {{ openstack_settings[conf] }}
        title: {{ sub }}
        settings: {{ openstack_settings }}
{% endfor %}
{% endfor %}

keystone database:
  cmd.run:
    - name: keystone-manage db_sync
    - user: keystone
    - require:
      - sls: mysql.server
      - file: keystone-keystone.conf
    - unless: mysql -s -N -u keystone --password={{ openstack_settings.passwords["keystone"|upper + "_DBPASS"] }} -D keystone -h {{ openstack_settings.hosts.database }} -e "select count(*) from project;"
    