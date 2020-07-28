/etc/salt/cloud.providers.d/crc-wow-vmware.conf:
     file.managed:
        - source: salt://salt-master-config-cloud-providers/crc-wow-vmware.conf
        - template: jinja

/etc/salt/cloud.providers.d/rp-singlehop-vmware.conf:
     file.managed:
        - source: salt://salt-master-config-cloud-providers/rp-singlehop-vmware.conf
        - template: jinja