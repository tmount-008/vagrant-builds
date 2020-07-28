##### Run via:
##### sudo salt-run state.orch orch.update-servers-with-snapshot pillar='{"service_group":"put_update_group_here"}'

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

  {% set remove_all_snapshots = gen_id_('remove_all_snapshots') %} # Generate unique task name
  {{ remove_all_snapshots }}:
      salt.runner:
          - name: cloud.action
          - func: remove_all_snapshots
          - instance: {{ localhost }}
          - merge_snapshots: False

  # Send rocketchat notification
  {% set send_snapshot_failed_message = gen_id_('send_snapshot_failed_message') %} # Generate unique task name
  {{ send_snapshot_failed_message }}:
    module.run:
      - name: slack.call_hook
      - message: 'All snapshots for {{ node }} have been removed.'


{% endfor %}



