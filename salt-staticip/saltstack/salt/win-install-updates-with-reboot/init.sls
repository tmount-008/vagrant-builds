include:
  - win-install-security-updates

reboot_server:
  system.reboot:
    - message: This server is installing security updates and is about to be rebooted.
    - timeout: 1
    - only_on_pending_reboot: true