#If minion version is not current
{% if (salt['grains.get']('saltversion') != '2019.2.0') %}
  
  #If supported Linux OS
  {% if ((salt['grains.get']('os') == 'Ubuntu') or (salt['grains.get']('os') == 'RedHat')) %} 
    upgrade-salt-minion:
      cmd.run:
        - name: |
            exec 0>&- # close stdin
            exec 1>&- # close stdout
            exec 2>&- # close stderr
            nohup /bin/sh -c 'salt-call --local pkg.install salt-minion && salt-call --local service.restart salt-minion' &
        # - onlyif: "[[ $(salt-call --local pkg.upgrade_available salt-minion 2>&1) == 'True' ]]" 
  {% endif %}

  #If Windows OS
  {% if (salt['grains.get']('os') == 'Windows') %}

    ## Schedule a task to run the installer in a few minutes

    schtasks /create /SC ONCE /ST ((Get-Date).AddMinutes(3).ToString('HH:mm')) /F /TN _update_salt_minion /TR "C:\ProgramData\chocolatey\choco.exe install rp-salt-minion-2019.2.0 -s https://cmchrepo.radpartners.com/nuget/rp-choco/ --force -y" /RU 'SYSTEM' /RL HIGHEST:
      cmd.run:
        - shell: powershell


  {% endif %}

{% endif %}
