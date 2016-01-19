{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    - apache.config
    - apache.vhosts.standard
    
{% from "apache/map.jinja" import apache with context %}

keystone packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.keystone }}
    
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

keystone config:
  file.recurse:
    - name: /etc/keystone
    - source: salt://openstack/files/etc/keystone
    - makedirs: True
    - template: jinja
    - context:
        settings: {{ openstack_settings }}
        
keystone database:
  cmd.run:
    - name: keystone-manage db_sync
    - user: keystone
    - require:
      - sls: mysql.server
      - file: keystone config
    - unless: mysql -s -N -u keystone --password={{ openstack_settings.passwords["keystone"|upper + "_DBPASS"] }} -D keystone -h {{ openstack_settings.hosts.database }} -e "select count(*) from project;"
    