##### Run via:
##### sudo salt-run state.orch orch.update-servers-linux pillar='{"service_group":"dev_service_group"}'

##### Combines paramater key & value into single variable
{% set update_target = "service_group:" ~ pillar.get('service_group', {}) %}

##### Creates array of devices with the grain value for update group matches the value after service_group:
{% set mine_info = salt['saltutil.runner']('mine.get', tgt=update_target, fun='grains.item', tgt_type='grain')%}

##### Creates array of device names
{% set nodes = mine_info.keys() | list %}

##### Creates array with all grain data for all nodes imported
{% set all_grains = salt.saltutil.runner('cache.grains', tgt=','.join(nodes), tgt_type='list') %}

##### Cycle through all nodes in grain
{% for node in nodes %}

  {# Create macro to generate unique state IDs that we can easily reuse. #}
  {%- macro gen_id_(name) -%}
    {{ name }}_{{ node }}_{{ loop.index }}
  {%- endmacro -%}

  ##### Check if snapshot is required
  ## Set variables
  {% set localhost = all_grains[node].get('localhost', {})|upper %}
  {% set snapshot_before_update = all_grains[node].get('snapshot_before_update', {}) %}

  ##### If snapshot required - If grain key snapshot_before_update has value of true
  {% if 'true' in snapshot_before_update|lower %}
    {% set remove_all_snapshots = gen_id_('remove_all_snapshots') %} # Generate unique task name



      ## Set UTC date & time to variable 
      {% set date_UTC = salt['cmd.shell']('echo $(date -u)')%}
      {% set date_readable = salt['cmd.shell']('echo $(date +%d%b%Y)')%}
      {% set vm_snapshot_name = ["salt ",date_readable]|join %}
      
      ##### Create snapshot of node & set output to variable
      {% set create_snapshot = gen_id_('create_snapshot') %} # Generate unique task name
      {% set snapshot_output = salt['saltutil.runner']('cloud.action', func='create_snapshot', instance=localhost, snapshot_name=vm_snapshot_name, description=date_UTC, memdump='False')%}
      
      ## Strip special characters and formatting from variable
      {% set snapshot_output = snapshot_output|escape|striptags|string %}
  
  ## Snapshot not required
  {% else %}
      # Set variable indicating snapshot not required 
      {% set snapshot_output = 'Not required' %}

  {% endif %}
  
  ##### Snapshot successful or not required
  {% if 'Snapshot created succesfully' or 'Not required' in snapshot_output %}

    

    ##### Apply pkg holds to node
    ## Add update_holds grain to variable
    {% set update_holds = all_grains[node].get('update_holds', {}) %}
    {% set apply_pkg_hold = gen_id_('apply_pkg_hold') %} # Generate unique task name
    {% set echo_no_holds = gen_id_('echo_no_holds') %} # Generate unique task name
    ## If there are update holds to apply
    {% if update_holds|length != 0  %}
      {{apply_pkg_hold}}:
        module.run:
          - name: pkg.hold
          - tgt: {{node}}
          - pkgs: {{ update_holds }}
          
    ## If no holds, make note of it
    {% else %}
      {{echo_no_holds}}:
        cmd.run:
          - names:
            - echo No update holds to apply
    {% endif %}

    ##### Apply updates to server
    {% set apply_updates = gen_id_('apply_updates') %} # Generate unique task name
    {{ apply_updates }}: 
      salt.state: 
        - tgt: {{ node }}
        - sls: system-update
        - require_any: 
          - salt: {{ apply_pkg_hold }}
          - cmd:  {{ echo_no_holds }}

    
    ##### Reboot server
    {% set reboot_node = gen_id_('reboot_node') %} # Generate unique task name
      {{reboot_node}}: 
        salt.function: 
          - name: system.reboot
          - tgt: {{ node }}

    ##### Wait for salt minion to start after reboot
    {% set wait_for_node_reboot = gen_id_('wait_for_node_reboot') %} # Generate unique task name
      {{wait_for_node_reboot}}: 
        salt.wait_for_event: 
          - name: salt/minion/*/start
          - id_list:
            - {{ node }}
          - require:
            - salt: {{reboot_node}}

    ##### Send rocketchat notification
    {% set send_node_success_message = gen_id_('send_node_success_message') %} # Generate unique task name
      {{ send_node_success_message }}:
        module.run:
          - name: slack.call_hook
          - message: '{{ node }} has been successfully updated and rebooted. '
          - require:
            - salt: {{wait_for_node_reboot}}


  ##### Snapshot not successful
  {% else %}
    {% set node_update_status = 'Failed' %}
    # Send rocketchat notification
    {% set send_snapshot_failed_message = gen_id_('send_snapshot_failed_message') %} # Generate unique task name
    {{ send_snapshot_failed_message }}:
      module.run:
        - name: slack.call_hook
        - message: '{{ node }} has not been updated. Salt was unable to create a snapshot.'
  
  {% endif %}

{% endfor %}



