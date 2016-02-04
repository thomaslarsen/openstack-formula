{% from "openstack/map.jinja" import openstack_settings with context %}
{% set admin_url = "http://" + openstack_settings.hosts.keystone + ":" + openstack_settings.keystone_admin_port + "/v" + openstack_settings.keystone_api_version %}

include:
    - openstack
    
glance packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.glance }}
    - require:
      - pkg: openstack dependencies
      
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
    - unless: mysql -s -N -u glance --password={{ openstack_settings.passwords["glance"|upper + "_DBPASS"] }} -D glance -h {{ openstack_settings.hosts.database }} -e "select count(*) from {{ openstack_settings.db_table_test.glance }};"
    
{% for service in openstack_settings.services.glance %}
{{ service }}:
  service.running:
    - enable: True
    - require:
      - cmd: glance database
    - watch:
      - file: glance-glance-api.conf
{% endfor %}

{% if openstack_settings.images is defined %}
{% for name, image in openstack_settings.images.items() %}
download image {{ name }}:
  file.managed:
    - name: /tmp/glance-image-{{ name }}
    - source: {{ image.url }}
    - source_hash: {{ image.checksum }}
  
add image {{ name }}: 
  cmd.run:
    - name: glance image-create --name {{ name }} --file /tmp/glance-image-{{ name }} --disk-format {{ image.disk_format }} --container-format {{ image.container_format }} {% if image.public is defined %}--visibility public{% endif %}
    - env:
      - OS_AUTH_URL: "{{ admin_url }}"
      - OS_PROJECT_DOMAIN_ID: {{ openstack_settings.admin_project_domain }}
      - OS_USER_DOMAIN_ID: {{ openstack_settings.admin_project_user_domain }}
      - OS_PROJECT_NAME: {{ openstack_settings.admin_project_name }}
      - OS_USERNAME: {{ openstack_settings.admin_project_user }}
      - OS_PASSWORD: {{ openstack_settings.passwords.ADMIN_PASS }}
    - require:
      - file: download image {{ name }}
    - unless: nova image-show {{ name }}
{% endfor %}
{% endif %}