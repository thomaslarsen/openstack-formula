{% from "openstack/map.jinja" import openstack_settings with context %}

{% set admin_url = "http://" + openstack_settings.hosts.keystone + ":" + openstack_settings.keystone_admin_port + "/v" + openstack_settings.keystone_api_version %}

include:
  - openstack.keystone
  
{% for role_name in openstack_settings.role %}
create role {{ role_name }}:
  cmd.run:
    - name: openstack role create {{ role_name }}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
    - require:
      - cmd: keystone database
    - unless: openstack role show {{ role_name }}
{% endfor %}

{% for user_name, user in openstack_settings.user.items() %}
create user {{ user_name }}:
  cmd.run:
    - name: |
        openstack user create {{ user_name }} \
        --password {{ user.password }} \
        --domain {{ user.domain }} \
        {% if user.description is defined %}--description "{{ user.description }}"{% endif %}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
    - require:
      - cmd: keystone database
    - unless: openstack user show {{ user_name }}
{% endfor %}

{% for project_name, project in openstack_settings.project.items() %}
create project {{ project_name }}:
  cmd.run:
    - name: |
        openstack project create {{ project_name }} \
        --domain {{ project.domain }} \
        {% if project.description is defined %}--description "{{ project.description }}"{% endif %}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
    - require:
      - cmd: keystone database
    - unless: openstack project show {{ project_name }}
{% if project.user is defined %}
{% for user_name, role in project.user.items() %}
create user {{ user_name }} role {{ role.role }} in project {{ project_name }}:
  cmd.run:
    - name: |
        openstack role add {{ role.role }} \
        --project {{ project_name }} \
        --user {{ user_name }} \
        {% if role.group is defined %}--group {{ role.group }}{% endif %} \
        {% if role.inherited is defined %}{% if role.inherited %}--inherited{% endif %}{% endif %}
    - env:
      - OS_TOKEN: "{{ openstack_settings.passwords.KEYSTONE_ADMIN_TOKEN }}" 
      - OS_URL: "{{ admin_url }}"
      - OS_IDENTITY_API_VERSION: "{{ openstack_settings.keystone_api_version }}"
    - unless: [ -n "$(openstack role list --user {{ user_name}} --project {{ project_name }})" ]
        
create {{ user_name }}-{{ project_name }} script:
  file.managed:
    - name: /root/{{ user_name }}-{{ project_name }}-openrc.sh
    - source: salt://openstack/files/client_script.sh
    - mode: 755
    - template: jinja
    - context:
        project_name: {{ project_name }}
        role_name: {{ role.role }}
        user_name: {{ user_name }}
{% endfor %}
{% endif %}
{% endfor %}

