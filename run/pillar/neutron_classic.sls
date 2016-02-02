openstack:
  neutron:
    DEFAULT:
      service_plugins: 
        - router
        - neutron.services.firewall.fwaas_plugin.FirewallPlugin
      allow_overlapping_ips: 'True'
      core_plugin: 'ml2'
      
  ml2_conf: 
    ml2: 
      type_drivers: 
        - flat
        - vxlan
      tenant_network_types:
        - vxlan
      mechanism_drivers:
        - linuxbridge
        - l2population
    ml2_type_flat:
      flat_networks: 
        - public
    ml2_type_vlan:
      network_vlan_ranges: 
        - external
        - 'vlan: 100:199'
    ml2_type_vxlan:
      vxlan_group: 239.1.1.1
      vni_ranges:
        - '1:1000'
        
  linuxbridge_agent:
    vxlan:
      enable_vxlan: 'True'
      l2_population: 'True'
      
  l3_agent:
    DEFAULT:
      interface_driver: 'neutron.agent.linux.interface.BridgeInterfaceDriver'
      external_network_bridge: ''
      use_namespaces: True
      router_delete_namespaces: True
      
  dhcp_agent:
    DEFAULT:
      use_namespaces: True
      dhcp_delete_namespaces: True
      
      