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
      
            