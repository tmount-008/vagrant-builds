##### Source: https://www.powershellgallery.com/packages/PSWindowsUpdate/1.5.2.2/Content/Get-WUInstall.ps1
## Requires PowerShell 5.0
## -https://www.andersrodland.com/deploy-windows-management-framework-51-with-sccm/


## Download all available updates - No Install
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force;Install-Module "PSWindowsUpdate" -Repository "PSGallery" -Force ;Import-Module "PSWindowsUpdate"; Get-WUInstall -MicrosoftUpdate -Category "Security Updates","Critical Updates","Service Packs" -Download -AcceptAll



####   sudo salt CRCDist* cmd.script salt://win-download-security-updates/download-availableupdates.ps1 shell=powershell env='ExecutionPolicy: "bypass"' cwd='C:\salt\'