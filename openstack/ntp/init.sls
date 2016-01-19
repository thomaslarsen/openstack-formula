chrony:
    pkg.installed: []
    
    service.running:
        - name: chronyd
        - enable: True
        - require:
            - file: /etc/chrony.conf
            - pkg: chrony