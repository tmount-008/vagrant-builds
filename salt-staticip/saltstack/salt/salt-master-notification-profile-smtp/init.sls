/etc/salt/minion.d/smtp.conf:
     file.managed:
        - source: salt://salt-master-notification-profile-smtp/smtp.conf
        - template: jinja
