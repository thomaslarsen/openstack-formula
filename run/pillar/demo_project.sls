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
          role: user
        admin:
          domain: default
          description: Admin user
          role: admin
          