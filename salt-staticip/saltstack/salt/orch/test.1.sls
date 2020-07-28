{% set mine_info = salt['saltutil.runner']('mine.get', tgt='updategroup:testdev', fun='grains.item', tgt_type='grain')%}

# 1. Create snapshot of vm
### May need to convert minion ID to uppercase & remove domain suffix
{% set date_readable = salt['cmd.shell']('echo (date +%d%b%Y)')%}
{% set date_UTC = salt['cmd.shell']('echo $(date -u)')%}

test_run:
  salt.state:
    - tgt: {{mine_info}}
    - sls:
      - repo-patchman
  
  test.ping:
    salt.function:
      - tgt: {{ minion_id }}

test_echo:
  cmd.run:
    - names:
      - echo {{ mine_info.grains }}

{% set nodes = salt.pillar.get('nodes', []) %}
{% set mine_info = salt['saltutil.runner']('mine.get', tgt='updategroup:testdev', fun='grains.item', tgt_type='grain')%}
#{% set minion_ids = mine_info.keys() | list %}
{% set pillardata = salt.saltutil.runner('pillar.show_pillar', kwarg={'minion': '*'}) %}
#{% set nodes = salt.pillar.get('nodes', []) %}
{%- for tcrcsatmin01, addrs in salt['mine.get']('data['id']', 'update_group') %}
  {{ addrs[0] }}
{% endfor %}

write-pillar-file:
  file.managed:
    - name: /tmp/mypillar.txt
    - contents:
      - {{ pillardata }}

write-variable:
  file.managed:
    - name: /tmp/vm_details.txt
    - contents:
      - {{ vm_details|escape|striptags|string }}


{% set ip = salt['saltutil.runner']('cache.grains', tgt=tcrcsatmin01)[tcrcsatmin01]['fqdn_ip4'][0] %}






minions = salt.saltutil.runner('cache.mine', tgt='G@location:uk', expr_form='compound') %}

{% for minion_id in minions %}
deploy_{{ minion_id }}:


  salt.function:
    - tgt: {{ minion_id }}
    - name: cmd.run
    - kwarg:
        cmd: echo "Deploying {{ minion_id }}"
{% endfor %}



      # {{ send_smtp_message }}:
      #   smtp.send_msg:
      #     - name: 'Server successfully updated and rebooted: {{ node }}'
      #     - profile: smtp_profile
      #     - subject: 'Server Updated: {{ fqdn }}'
      #     - recipient: travis.mount@radpartners.com
      #     - sender: smtp_salt@RadiologyPartners.onmicrosoft.com
      #     - use_ssl: True
    


      #   ## Generate unique task name
  #   {% set send_message = gen_id_('send_message') %}
  #   ## Send failure notification
  #   {{ send_message }}:
  #     smtp.send_msg:
  #       - name: 'ERROR - Snapshot not created for server: {{ update_target }}'
  #       - profile: smtp_profile
  #       - subject: 'server name: {{ fqdn|upper }}'
  #       - recipient: travis.mount@radpartners.com
  #       - sender: smtp_salt@RadiologyPartners.onmicrosoft.com
  #       - use_ssl: True








  {% for cloud_provider_dic in vm_details %}
  {# Create macro to generate unique state IDs that we can easily reuse. #}
  {%- macro gen_id1_(name) -%}
    {{ name }}_{{ loop.index }}
  {%- endmacro -%}
    
    {% for item in cloud_provider_dic %}
      {%- macro gen_id2_(name) -%}
        {{ name }}_{{ loop.index }}
      {%- endmacro -%}
      {% set echo_no_holds = gen_id2_('echo_no_holds') %} # Generate unique task name
      {{echo_no_holds}}:
        cmd.run:
          - names:
            - echo {{ item }}

    {% endfor %}

{% endfor %}


{% set vm_details = vm_details|replace("}"," ") %}
{% set vm_details = vm_details|replace(":","--") %}







{% for item in vm_details %}
  {%- macro gen_id2_(name) -%}
    {{ name }}_{{ loop.index }}
  {%- endmacro -%}
  {% set echo_no_holds = gen_id2_('echo_no_holds') %} # Generate unique task name
  {{echo_no_holds}}:
    cmd.run:
      - names:
        - echo {{ item }}

{% endfor %}