{% set min_info = salt['saltutil.runner']('mine.get', tgt=updategroup:testdev, fun='grains.item', tgt_type='grain'%}

# 1. Create snapshot of vm
### May need to convert minion ID to uppercase & remove domain suffix
{% set date_readable = salt['cmd.shell']('echo (date +%d%b%Y)')%}}
{% set date_UTC = salt['cmd.shell']('echo $(date -u)')%}}

test_run:
  salt.state:
    - tgt: 'tcrc*'
    - sls:
      - repo-patchman

# create-snapshot:
#     salt.runner:
#         - name: cloud.action
#         - func: create_snapshot
#         - instance: {{ minion_id }}
#         - snapshot_name: {{ date_readable }}
#         - description: {{ date_UTC }}
#         - memdump: False

# # 3. Send notification that snapshot was complete including snapshot name

# # 4. Apply update exclusions



# # 5. Apply updates to server
# apply-update-state-on-minion:
#     salt.state:
#         tgt: server
#         sls: system-update
#         require:
#             - salt: create-snapshot-of-vm


# # 6. Send notification that updates were completed


# # 7. Clean up snapshots


# ## Run command
# ## sudo salt-run state.orch orch.update-linux-system pillar=