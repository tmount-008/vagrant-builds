{% if ((salt['grains.get']('os') == 'Ubuntu') or (salt['grains.get']('os') == 'RedHat') or (salt['grains.get']('os') == 'CentOS')) %}

/etc/salt/minion.d/startup-states.conf:
     file.managed:
        - source: salt://salt-minion-config/startup-states.conf
        - template: jinja

/etc/salt/minion.d/log-settings.conf:
     file.managed:
        - source: salt://salt-minion-config/log-settings.conf
        - template: jinja

{% endif %}

{% if salt['grains.get']('os') == 'Windows' %}

C:\salt\conf\minion.d\keepalive-settings.conf:
     file.managed:
        - source: salt://salt-minion-config/keepalive-settings.conf
        - template: jinja

C:\salt\conf\minion.d\startup-states.conf:
     file.managed:
        - source: salt://salt-minion-config/startup-states.conf
        - template: jinja

{% endif %}