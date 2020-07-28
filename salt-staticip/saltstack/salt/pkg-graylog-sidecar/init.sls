## https://docs.graylog.org/en/3.0/pages/sidecar.html
include:
  - pkg-filebeat

graylog-sidecar:
  #
  pkg.installed:
    - name: graylog-sidecar
    - sources: 
      {% if ((salt['grains.get']('os') == 'CentOS') or (salt['grains.get']('os') == 'RedHat')) %}
      - graylog-sidecar: {{pillar['rpm-graylog-sidecar']}}
      {% endif %}
      {% if (salt['grains.get']('os') == 'Ubuntu') %}
      - graylog-sidecar: {{pillar['deb-graylog-sidecar']}}
      {% endif %}
    - version: {{pillar['graylog-sidecar-version']}}
  #
  cmd.run:
    - name: graylog-sidecar -service install
    - require:
      - pkg: graylog-sidecar
    - creates: /etc/systemd/system/graylog-sidecar.service
  #
  service.running:
    - enable: True
    - watch: 
      - file: /etc/graylog/sidecar/sidecar.yml
      - pkg: filebeat

 
/etc/graylog/sidecar/sidecar.yml:
  file.managed:
    - source: salt://pkg-graylog-sidecar/sidecar.yml
    - template: jinja
    - require:
      - pkg: graylog-sidecar


