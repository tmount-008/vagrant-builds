/etc/salt/master.d/rocketchat-api.conf:
     file.managed:
        - source: salt://salt-master-notification-profile-rocketchat-api/rocketchat-api.conf
        - template: jinja
