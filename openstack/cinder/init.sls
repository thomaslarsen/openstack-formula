{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    
{% for sub, element in openstack_settings.config.cinder.items() %}
{% for file, conf in element.files.items() %}
{{ sub }}-{{ file }}:
  file.managed:
    - name: {{ openstack_settings.config_base }}/{{ element.path }}/{{ file }}
    - source: salt://openstack/files/conf.jinja
    - template: jinja
    - makedirs: True
    - context:
        component: cinder
        conf: {{ openstack_settings[conf] }}
        title: {{ sub }}
        settings: {{ openstack_settings }}
{% endfor %}
{% endfor %}

cinder volume dir:
  file.directory:
    - name: {{ openstack_settings.cinder_volumes_dir }}
    - user: cinder
    - group: cinder
    - makedirs: True
  
    