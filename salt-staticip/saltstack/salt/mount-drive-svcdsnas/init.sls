create-account-file:
      file.managed:
        - name: /etc/.svcdsnas
        - source: salt://mount-drive-svcdsnas/.svcdsnas
        - mode: 600


add-cred-value-to-file:
    file.append:
        - name: /etc/.svcdsnas
        - text:
            - username={{pillar['svcdsnas-username']}}
            - password={{pillar['svcdsnas-password']}}
    



/etc/fstab:
    file.append:
        - text:
            - #mount datascience share
            - //pcrcfpa02.columbusrad.local/datascience /mnt/nas cifs credentials=/etc/.svcdsnas 0 0

