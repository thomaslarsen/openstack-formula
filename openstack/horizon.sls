{% from "openstack/map.jinja" import openstack_settings with context %}

include:
    - openstack
    
horizon packages:
  pkg.installed:
    - pkgs: {{ openstack_settings.dependencies.horizon }}
    
{{ openstack_settings.config_base }}/openstack-dashboard/local_settings:
  file.managed:
    - source: salt://openstack/files/horizon.jinja
    - makedirs: True
    - template: jinja
    - context:
        component: horizon
        conf: {{ openstack_settings.horizon }}
        title: Dashboard - local settings
        settings: {{ openstack_settings }}
    - watch_in:
      - service: apache
      - service: memcached