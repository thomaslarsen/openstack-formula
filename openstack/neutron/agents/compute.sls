{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    - openstack.neutron

{% set node_class = 'neutron_compute' %}
    
{% for agent in openstack_settings.neutron_agents %}
{% if openstack_settings.dependencies[node_class].agents[agent] is defined %}
{{ node_class }}_{{ agent }} packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies[node_class].agents[agent] }}
{% endif %}    

{% set config_files = [] %}
{% set element = openstack_settings.config.neutron_agents[agent] %}
{% for file, conf in element.files.items() %}
{% if openstack_settings[conf] is defined %}
{% do config_files.append(node_class + '-' + agent + '-' + file) %}
{{ node_class }}-{{ agent }}-{{ file }}:
  file.managed:
    - name: {{ openstack_settings.config_base }}/{{ element.path }}/{{ file }}
    - source: salt://openstack/files/conf.jinja
    - template: jinja
    - makedirs: True
    - context:
        component: neutron agent
        conf: {{ openstack_settings[conf] }}
        title: {{ agent }}
        settings: {{ openstack_settings }}
{% endif %}
{% endfor %}

{% if openstack_settings.services[node_class].agents[agent] is defined %}
{% for service in openstack_settings.services[node_class].agents[agent] %}
{{ node_class }}_{{ agent }}-{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: True
    - require:
      - pkg: {{ node_class }}_{{ agent }} packages
    - watch:
{% for config_file in config_files %}
      - file: {{ config_file }}
{% endfor %}
{% endfor %}
{% endif %}
{% endfor %}

