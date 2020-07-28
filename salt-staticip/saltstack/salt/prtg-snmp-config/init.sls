net-snmp:
  pkg.installed:
    - name: net-snmp

net-snmp-utils:
  pkg.installed:
    - name: net-snmp-utils
    - require: 
      - pkg: net-snmp

net-snmp-enabled:
  service.enabled:
    - name: snmpd
    - require:
      - pkg: net-snmp-utils

net-snmp-config:
  service.running:
    - name: snmpd
    - watch:
      - file: /etc/snmp/snmpd.conf
  file.managed:
    - name: /etc/snmp/snmpd.conf
    - source: salt://prtg-snmp-config/snmpd.conf
    - template: jinja
    - require: 
      - service: net-snmp-enabled