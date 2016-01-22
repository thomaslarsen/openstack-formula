openstack:
  nodes:
    stack: 127.0.0.1
  hosts:
    controller: stack
    database: stack
    keystone: stack
    rabbit: stack
    glance: stack
    metadata: stack
    
  loopback:
    volumes:
      loopback:
        bs: 1k
        seek: 5M
        count: '0'
        dev: loop1
        volume_group: loop1-volumes
        
  cinder:
    DEFAULT:
      enabled_backends: loop1
    loop1:
      volume_driver: cinder.volume.drivers.lvm.LVMVolumeDriver
      volume_group: loop1-volumes
      iscsi_protocol: iscsi
      iscsi_helper: lioadm
      volume_backend_name: loop1
      
  linuxbridge_agent: 
    linux_bridge:
      physical_interface_mappings: 'public:enp0s3'
  ml2_conf:
    ml2_type_flat:
      flat_networks: public
      
  networks:
    public:
      shared: True
      provider: 
        physical_network: public
        network_type: flat
        