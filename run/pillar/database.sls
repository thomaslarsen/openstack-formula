include:
  - mysql

mysql:
    database:
        - keystone
        - glance
        - nova
        - neutron
        - cinder
    user:
        keystone:
            password: 'secret'
            host: localhost
            databases:
                - database: keystone
                  grants: ['all privileges']
        glance:
            password: 'secret'
            host: localhost
            databases:
                - database: glance
                  grants: ['all privileges']
        nova:
            password: 'secret'
            host: localhost
            databases:
                - database: nova
                  grants: ['all privileges']
        neutron:
            password: 'secret'
            host: localhost
            databases:
                - database: neutron
                  grants: ['all privileges']
        cinder:
            password: 'secret'
            host: localhost
            databases:
                - database: cinder
                  grants: ['all privileges']
                  
mongodb:
  settings:
    db_path: /var/lib/mongodb