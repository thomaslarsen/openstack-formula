{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - epel

openstack core:
    pkg.installed:
        - pkgs:
            - centos-release-openstack-{{ openstack_settings.openstack_release }}

openstack dependencies:
    pkg.installed:
        - pkgs:
            - python-openstackclient
            - openstack-selinux
        - require:
            - pkg: openstack core
      
{% for component, conf in openstack_settings.config.items() %}
{% for sub, element in conf.items() %}
{% for file, conf in element.files.items() %}
/tmp/openstack/{{ element.path }}/{{ file }}:
  file.managed:
    - source: salt://openstack/files/conf.jinja
    - template: jinja
    - makedirs: True
    - context:
        conf: {{ openstack_settings[conf] }}
        title: {{ component }}
        settings: {{ openstack_settings}}
{% endfor %}
{% endfor %}
{% endfor %}
