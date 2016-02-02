openstack:
  neutron:
    DEFAULT:
      service_plugins: ''
      core_plugin: 'ml2'
  ml2_conf: 
    ml2: 
      type_drivers: 'flat,vlan'
      tenant_network_types: ''
      mechanism_drivers: 'linuxbridge'
  linuxbridge_agent:
    vxlan:
      enable_vxlan: 'False'
      