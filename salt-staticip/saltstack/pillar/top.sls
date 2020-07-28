base:
  '*':
    - common
    - mine-baseline
    - graylog-sidecar-settings
  
  'roles:data-science-project':
    - match: grain
    - account-svcdsnas

  'roles:salt-master':
    - match: grain
    - account-crc-wow-vsphere
    - account-rp-singlehop-vpshere
    - account-smtp-profile
    - account-rocketchat-api
    - schedule-apply-highstate

  'ad-site:radpartners.com':
    - match: grain
    - domain-details-radpartners

  'ad-site:columbusrad.local':
    - match: grain
    - domain-details-columbusrad
  
  'S@10.21.11.0/24 or S@10.21.10.0/24 or S@10.21.20.0/24':
    - match: compound
    - snmp-config-singlehop

  'service_group:crc_manual_updates':
    - match: grain
    - schedule-weekly-win-download-security-updates

