{% from "openstack/map.jinja" import openstack_settings with context -%}
{% set user = openstack_settings.user[user_name] -%}
{% set project = openstack_settings.project[project_name] -%}
export OS_PROJECT_DOMAIN_ID={{ project.domain }}
export OS_USER_DOMAIN_ID={{ user.domain }}
export OS_PROJECT_NAME={{ project_name }}
export OS_TENANT_NAME={{ project_name }}
export OS_USERNAME={{ user_name }}
export OS_PASSWORD={{ user.password }}
export OS_AUTH_URL={{ openstack_settings.service.keystone.endpoint[user.endpoint].url }}
export OS_IDENTITY_API_VERSION=3
