{% set my_ip = salt['grains.get']('ipv4')[0] %}
openstack:
  nodes:
    stack: {{ my_ip }}
  hosts:
    controller: localhost
    database: localhost
    keystone: localhost
    rabbit: localhost
    glance: localhost
    metadata: localhost
    
  loopback:
    user: cinder
    group: cinder
    volumes_dir: /var/lib/cinder/volumes
    volumes:
      loopback:
        bs: 1k
        seek: 5M
        count: '0'
        dev: loop1
        volume_group: loop1-volumes
        
  images:
    cirros:
      url: http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
      checksum: md5=ee1eca47dc88f4879d8a229cc70a07c6
      public: true
      container_format: bare
      disk_format: qcow2
      
  nova:
    DEFAULT:
      my_ip: {{ my_ip }}
    libvirt:
      virt_type:
        - qemu
        
  cinder:
    DEFAULT:
      my_ip: {{ my_ip }}
      enabled_backends: loop1
    loop1:
      volume_driver: cinder.volume.drivers.lvm.LVMVolumeDriver
      volume_group: loop1-volumes
      iscsi_protocol: iscsi
      iscsi_helper: lioadm
      volume_backend_name: loop1
      
  linuxbridge_agent: 
    linux_bridge:
      physical_interface_mappings: 
        - 'public:enp0s3'
    vxlan:
      local_ip: = {{ my_ip }}      

      
      
  networks:
    public:
      shared: True
      external: True
      provider: 
        physical_network: public
        network_type: flat
      subnet:
        public:
          ip: 10.0.2.0/24
          gateway: 10.0.2.2
          dns: 10.0.2.3
          dhcp:
            start: 10.0.2.32
            end: 10.0.2.63
    private:
      subnet:
        private:
          ip: 172.16.1.0/24
          gateway: 172.16.1.1
          dns: 10.0.2.3
          
  routers:
    router:
      gateway: public
      interface:
        - private
      
        