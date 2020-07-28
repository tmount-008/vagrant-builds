install-securityupdates:
  chocolatey.installed:
    - name: rp-installsecurityupdates
    - source: 'https://cmchrepo.radpartners.com/nuget/rp-choco/'
    - force: True