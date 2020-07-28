/etc/salt/master.d/timeout-settings.conf:
     file.managed:
        - source: salt://salt-master-config/timeout-settings.conf
        - template: jinja

/etc/salt/master.d/nodegroups.conf:
     file.managed:
        - source: salt://salt-master-config/nodegroups.conf
        - template: jinja

/etc/salt/master.d/log-settings.conf:
     file.managed:
        - source: salt://salt-master-config/log-settings.conf
        - template: jinja

