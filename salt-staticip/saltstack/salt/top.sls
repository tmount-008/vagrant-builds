base:
    '*':
      - salt-minion-config

    'roles:salt-master':
      - match: grain
      - salt-master-config
      - salt-master-config-cloud-providers
      - salt-master-notification-profile-smtp
      - salt-master-notification-profile-rocketchat-api
      - pkg-pyvmomi
      - pkg-graylog-sidecar

    'G@ad-site:columbusrad.local or G@ad-site:radpartners.com':
      - match: compound
      - join-ad-domain

    'os:Windows':
      - match: grain
      - win-install-chocolatey

    'saltversion:2018.3.3':
      - match: grain
      - salt-minion-upgrade-v2019-2-0


    
    