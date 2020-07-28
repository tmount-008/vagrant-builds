schedule:
  win-download-security-updates:
    function: state.apply
    args:
      ## Download available security updates from Microsoft
      - win-download-security-updates
    ## Random delay up to 3 hours
    play: 10800 
    ## Run every Sunday at 0615
    when: 
      - Sunday 6:15am