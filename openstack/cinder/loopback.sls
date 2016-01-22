{% from "openstack/map.jinja" import openstack_settings with context %}

include:
  - openstack.cinder

{% for image,dd in openstack_settings.loopback.volumes.items() %}
create sparse image {{ image }} for loopback {{ dd.dev }}:
  cmd.run:
    - name: dd of={{ image }} bs={{ dd.bs }} seek={{ dd.seek }} count={{ dd.count }}
    - cwd: {{ openstack_settings.cinder_volumes_dir }}
    - user: cinder
    - group: cinder
    - unless: test -e {{ openstack_settings.cinder_volumes_dir }}/{{ image }}
    
add loopback dev {{ dd.dev }}:
  cmd.run:
    - name: losetup /dev/{{ dd.dev }} {{ openstack_settings.cinder_volumes_dir }}/{{ image }}
    - unless: test -e /dev/{{ dd.dev }}
    - require:
      - cmd: create sparse image {{ image }} for loopback {{ dd.dev }}
  
pv for /dev/{{ dd.dev }}:
  lvm.pv_present:
    - name: /dev/{{ dd.dev }}
    - require:
      - cmd: add loopback dev {{ dd.dev }}
    
volume group {{ dd.volume_group }} for /dev/{{ dd.dev }}:
  lvm.vg_present:
    - name: {{ dd.volume_group }}
    - devices: /dev/{{ dd.dev }}
    - require:
      - lvm: pv for /dev/{{ dd.dev }}
    
{% endfor %}