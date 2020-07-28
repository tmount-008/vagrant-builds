mine_functions:
  network.interfaces: []
  status.uptime: []
  
  ## Below this work  
  update_group: 
   - mine_function: grains.get
   - service_group
  
  hostname: 
   - mine_function: grains.get
   - localhost