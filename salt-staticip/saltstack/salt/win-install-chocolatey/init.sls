{% if (salt['grains.get']('os') == 'Windows') %}
  
  chocolatey_executable_exists:
    file.exists:
      - name: C:\ProgramData\chocolatey\choco.exe


  chocolatey_install:
    module.run:
      - name: chocolatey.bootstrap
      - onfail: 
        - file: chocolatey_executable_exists

  chocolatey.add_source:
    module.run:
      - m_name: RP_Source
      - source_location: https://cmchrepo.radpartners.com/nuget/rp-choco/
      - onchanges: 
        - module: chocolatey_install

{% endif %}



