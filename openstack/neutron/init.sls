{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    
{% for sub, element in openstack_settings.config.neutron.items() %}
{% for file, conf in element.files.items() %}
{% if openstack_settings[conf] is defined %}
{{ sub }}-{{ file }}:
  file.managed:
    - name: {{ openstack_settings.config_base }}/{{ element.path }}/{{ file }}
    - source: salt://openstack/files/conf.jinja
    - template: jinja
    - makedirs: True
    - context:
        component: neutron
        conf: {{ openstack_settings[conf] }}
        title: {{ sub }}
        settings: {{ openstack_settings }}
{% endif %}
{% endfor %}
{% endfor %}

{{ openstack_settings.config_base }}/neutron/plugin.ini:
  file.symlink:
    - target: {{ openstack_settings.config_base }}/neutron/plugins/ml2/ml2_conf.ini
    - require:
      - file: ml2-ml2_conf.ini
      
NetworkManager:
  service.dead:
    - enable: False