include:
    - mysql

mysql:
    database:
        - keystone
        - glance
        - nova
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
                  
mongodb:
  settings:
    db_path: /var/lib/mongodb