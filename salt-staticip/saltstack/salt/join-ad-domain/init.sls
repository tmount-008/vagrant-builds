{% if salt['grains.get']('domain-status') != 'joined' %}
{% set lsb_release_code = salt['cmd.shell']('echo $(lsb_release -sc)') %}
{% set lsb_release_description = salt['cmd.shell']('echo $(lsb_release -sd)') %}
{% set lsb_release_release = salt['cmd.shell']('echo $(lsb_release -sr)') %}
# Authenticate with SSSD and create user's home direcories*

# Install pre-reqs
sssd-tools:
  pkg.installed:
    - name: sssd-tools

repo-krb5-user-ub:
     pkgrepo.managed:
       - name: deb http://archive.ubuntu.com/ubuntu {{ lsb_release_code }}-security universe main
       - humanname: ubuntu krb5-user repo
       - require:
         - pkg: sssd-tools

provide-krb5-config:
  debconf.set:
    - name: krb5-config
    - data:
        'default_realm': {'type': 'string','value': '{{pillar['domain-name']}}'}
    - require:
      - pkgrepo: repo-krb5-user-ub

krb5-user:
  pkg.installed:
    - name: krb5-user
    - require: 
      - debconf: provide-krb5-config

adcli:
  pkg.installed:
    - name: adcli
    - require: 
      - pkg: krb5-user

samba-common-bin:
  pkg.installed:
    - name: samba-common-bin
    - require: 
      - pkg: adcli

realmd:
  pkg.installed:
    - name: realmd
    - require: 
      - pkg: samba-common-bin

/etc/krb5.conf:
  file.managed:
    - source: salt://join-ad-domain/krb5.conf
    - require: 
      - pkg: realmd
    - template: jinja

/etc/systemd/timesyncd.conf:
  file.managed:
    - source: salt://join-ad-domain/timesyncd.conf
    - require: 
      - file: /etc/krb5.conf
    - template: jinja

timedatectl set-ntp true:
  cmd.run:
    - require:
      - file: /etc/systemd/timesyncd.conf

systemctl restart systemd-timesyncd.service:
  cmd.run:
    - require:
      - cmd: timedatectl set-ntp true

timedatectl --adjust-system-clock:
  cmd.run:
    - require:
      - cmd: systemctl restart systemd-timesyncd.service

#Adds realmd.conf file
/etc/realmd.conf:
  file.managed:
    - source: salt://join-ad-domain/sssd.conf
    - template: jinja
  require:
    - cmd: timedatectl --adjust-system-clock

#Adds 1 line to the common-session file (To create home direct. for users)*
/etc/pam.d/common-session:
  file.append:
    - text:
      - session required pam_mkhomedir.so skel=/etc/skel/ umask=0022
    - require:
      - file: /etc/realmd.conf

#Joins active directory
join-AD:
   cmd.run:
     - name: echo {{pillar['domain-join-password']}} | realm --verbose join {{pillar['domain-name']}} --user={{pillar['domain-join-username']}} --computer-ou={{pillar['domain-join-target-ou']}} --install=/


#Adds sssd.conf file*
/etc/sssd/sssd.conf:
  file.managed:
    - source: salt://join-ad-domain/sssd.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
  require:
    - cmd: join-AD

#sssd service will restart when file /etc/sssd/sssd.conf is changed
sssd:
  pkg:
    - installed
  service:
    - running
    - file: /etc/sssd/sssd.conf
  require:
    - file: /etc/sssd/sssd.conf

domain-status:
  grains.present:
    - value: joined
  require:
    - pkg: sssd
    - cmd: join-AD

{% endif %}

ensure-grain-domain-status-exists:
  grains.exists:
    - name: domain-status