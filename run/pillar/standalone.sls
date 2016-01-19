openstack:
  hosts:
    controller: localhost
    compute: localhost
    block: localhost
    database: localhost
    keystone: localhost
    rabbit: localhost
    glance: localhost
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
  role:
    - admin
    - user
  user:
    admin:
      password: secret
      domain: default
      endpoint: admin
    demo:
      password: secret
      domain: default
      endpoint: public
    glance:
      password: secret
      domain: default
      endpoint: admin
    nova:
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
    demo:
      domain: default
      description: Demo project
      user:
        demo:
          domain: default
          description: Demo user
          role: user
          
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
      