mysql:
    lookup:
        server: mariadb-server
        client: mariadb-client
        service: mariadb
    server:
        lookup:
            server_config:
                sections:
                    mysqld_safe:
                        log_error: /var/log/mariadb/mariadb.log
                        pid_file: /var/run/mariadb/mariadb.pid
        
