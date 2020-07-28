## https://www.elastic.co/guide/en/beats/filebeat/current/setup-repositories.html

## Configure repo
## Install filebeats
## make sure filebeats service is running and runs at startup

filebeat-repo:
  pkgrepo.managed:
  {% if ((salt['grains.get']('os') == 'CentOS') or (salt['grains.get']('os') == 'RedHat')) %}
    - baseurl: https://artifacts.elastic.co/packages/7.x/yum
    - gpgcheck: 1
    - gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
  {% endif %}
  {% if (salt['grains.get']('os') == 'Ubuntu') %}
    - humanname: Elastic repository for 7.x packages
    - name: deb https://artifacts.elastic.co/packages/7.x/apt stable main
    - file: /etc/apt/sources.list.d/elastic-7.x.list
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
  {% endif %}

filebeat:
  pkg.installed:
    - requires:
      - pkgrepo: filebeat-repo
  service.running:
    - enable: True

# graylog-sidecar:
#   service.running:
#     - enable: True
#     - watch: 
#       - pkg: filebeat
