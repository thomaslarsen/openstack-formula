{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    
glance packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.glance }}
      
glance config:
  file.recurse:
    - name: /etc/glance
    - source: salt://openstack/files/etc/glance
    - makedirs: True
    - template: jinja
    - context:
        settings: {{ openstack_settings }}
        
glance database:
  cmd.run:
    - name: glance-manage db_sync
    - user: glance
    - require:
      - sls: mysql.server
      - file: glance config
    - unless: mysql -s -N -u glance --password={{ openstack_settings.passwords["glance"|upper + "_DBPASS"] }} -D glance -h {{ openstack_settings.hosts.database }} -e "select count(*) from images;"
    
{% for service in openstack_settings.services.glance %}
{{ service }}:
  service.running:
    - enable: True
    - require:
      - cmd: glance database
    - watch:
      - file: glance config
{% endfor %}