apache:
  lookup:
    use_require: True
  sites:
    wsgi-keystone-public:
      enabled: True
      template_file: salt://apache/vhosts/standard.tmpl 
      template_engine: jinja

      interface: '*'
      port: '5000'
      
      LogLevel: warn
      ErrorLog: /var/log/httpd/keystone-error.log
      CustomLog: /var/log/httpd/keystone-access.log

      DocumentRoot: /

      Directory:
        /usr/bin:
          Require: all granted

      Formula_Append: |
        WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
        WSGIProcessGroup keystone-public
        WSGIScriptAlias / /usr/bin/keystone-wsgi-public
        WSGIApplicationGroup %{GLOBAL}
        WSGIPassAuthorization On

    wsgi-keystone-admin:
      enabled: True
      template_file: salt://apache/vhosts/standard.tmpl 
      template_engine: jinja

      interface: '*'
      port: '35357'
      
      LogLevel: warn
      ErrorLog: /var/log/httpd/keystone-error.log
      CustomLog: /var/log/httpd/keystone-access.log

      DocumentRoot: /

      Directory:
        /usr/bin:
          Require: all granted

      Formula_Append: |
        WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
        WSGIProcessGroup keystone-admin
        WSGIScriptAlias / /usr/bin/keystone-wsgi-admin
        WSGIApplicationGroup %{GLOBAL}
        WSGIPassAuthorization On
        