openstack:
  user:
    demo:
      password: secret
      domain: default
      endpoint: public
  project:
    demo:
      domain: default
      description: Demo project
      user:
        demo:
          domain: default
          description: Demo user
          role:
            - admin
            - heat_stack_owner
          