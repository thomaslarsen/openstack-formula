mysql:
    server:
        root_password: 'foo'
        mysqld:
            # you can use either underscore or hyphen in param names
            bind-address: 0.0.0.0
            default-storage-engine: innodb
            innodb_file_per_table: True
            collation-server: utf8_general_ci
            init-connect: 'SET NAMES utf8'
            character-set-server: utf8      
            