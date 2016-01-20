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
  passwords:
    NEUTRON_PASS: secret
  service:
    keystone:
      description: Openstack Identity
      type: identity
      endpoint:
        public:
          region: RegionOne
          url: http://controller:5000/v3
        internal:
          region: RegionOne
          url: http://controller:5000/v3
        admin:
          region: RegionOne
          url: http://controller:35357/v3
    glance:
      description: "OpenStack Image service"
      type: image
      endpoint:
        public:
          region: RegionOne
          url: http://controller:9292
        internal:
          region: RegionOne
          url: http://controller:9292
        admin:
          region: RegionOne
          url: http://controller:9292
    nova:
      description: "OpenStack Compute service"
      type: compute
      endpoint:
        public:
          region: RegionOne
          url: "http://controller:8774/v2/%\\(tenant_id\\)s"
        internal:
          region: RegionOne
          url: "http://controller:8774/v2/%\\(tenant_id\\)s"
        admin:
          region: RegionOne
          url: "http://controller:8774/v2/%\\(tenant_id\\)s"
    neutron:
      description: "OpenStack Networking service"
      type: network
      endpoint:
        public:
          region: RegionOne
          url: http://controller:9696
        internal:
          region: RegionOne
          url: http://controller:9696
        admin:
          region: RegionOne
          url: http://controller:9696
  role:
    - admin
    - user
  user:
    admin:
      password: secret
      domain: default
      endpoint: admin
    glance:
      password: secret
      domain: default
      endpoint: admin
    nova:
      password: secret
      domain: default
      endpoint: admin
    neutron:
      password: secret
      domain: default
      endpoint: admin
  project:
    admin:
      domain: default
      description: Admin project
      user:
        admin:
          domain: default
          description: Admin user
          role: admin
    service:
      domain: default
      description: Service project
      user:
        glance:
          domain: default
          description: Glance user
          role: admin
        nova:
          domain: default
          description: Nova user
          role: admin
        neutron:
          domain: default
          description: Neutron user
          role: admin
          
rabbitmq:
  user:
    openstack:
      - password: secret
      - force: True
      - tags: monitoring, user
      - perms:
        - '/':
          - '.*'
          - '.*'
          - '.*'
      