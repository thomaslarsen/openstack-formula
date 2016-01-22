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
          