{% from "openstack/map.jinja" import openstack_settings with context %}
{% set loopback = openstack_settings.loopback %}

{{ loopback.volumes_dir }}:
  file.directory:
    - name: {{ loopback.volumes_dir }}
    - user: {{ loopback.user }}
    - group: {{ loopback.group }}
    - makedirs: True
    
{% for image,dd in loopback.volumes.items() %}
create image {{ image }} for loopback {{ dd.dev }}:
  cmd.run:
    - name: dd of={{ image }} bs={{ dd.bs }} seek={{ dd.seek }} count={{ dd.count }}
    - cwd: {{ loopback.volumes_dir }}
    - user: {{ loopback.user }}
    - group: {{ loopback.group }}
    - require:
      - file: {{ loopback.volumes_dir }}
    - unless: test -e {{ loopback.volumes_dir }}/{{ image }}
    
add loopback dev {{ dd.dev }}:
  cmd.run:
    - name: losetup /dev/{{ dd.dev }} {{ loopback.volumes_dir }}/{{ image }}
    - unless: test -e /dev/{{ dd.dev }}
    - require:
      - cmd: create image {{ image }} for loopback {{ dd.dev }}
  
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