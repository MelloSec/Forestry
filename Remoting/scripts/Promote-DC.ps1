param(
    [Parameter(Mandatory = $false, HelpMessage = "Name of domain")]
    [string]$DomainName = "mellosec.sunn"
)
Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
Import-Module -Name ActiveDirectory



# Install-ADDSForest -DomainName $DomainName -CreateDNSDelegation -DomainMode Win2019 -ForestMode Win2019 -DatabasePath "C:\Windows\NTDS" -SYSVOLPath "C:\windows\SYSVOL" -LogPath 'C:\Windows\NTDS'
# Install-ADDSDomainController -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainName "$DomainName" -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoGlobalCatalog:$false -SysvolPath 'C:\Windows\SYSVOL' -NoRebootOnCompletion:$true -Force:$true


# For a new forest
# Install-ADDSForest -DomainName $DomainName -CreateDNSDelegation -DatabasePath "C:\Windows\NTDS" -SYSVOLPath "C:\windows\SYSVOL" -LogPath 'C:\Windows\NTDS'