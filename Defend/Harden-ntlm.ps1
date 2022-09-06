# Work in progress, would like to have it run, check which type of system we're on and run the write commands.
# We'll get there
param(
    [Parameter(Mandatory = true, HelpMessage = "Version of SMB of you want enabled, enter 2 or 3")]
    [int]$SMB
)

# if OS = Servers, Workstations 
# Need a powershell function to test if the OS is windows server or professional or enterprise



# Disable LLMNR 
Write-Host -ForegroundColor Green "Disabling LLMNR"
REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient”
REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient” /v ” EnableMulticast” /t REG_DWORD /d “0” /f

# Disable NBT-NS
Write-Host -ForegroundColor Green "Disabling NBT-NS"
$regkey = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces"
Get-ChildItem $regkey |foreach { Set-ItemProperty -Path "$regkey\$($_.pschildname)" -Name NetbiosOptions -Value 2 -Verbose}

# Servers and Legacy
# Disable SMBv1 via registry on older Windows 7/XP
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 0 -Force

# If OS is server, use the the cmdlet for the server
Set-SmbServerConfiguration -disableSMB1Protocol $true

# if $SMB = 2 and OS = server
# Set-SmbServerConfiguration -enableSMB2Protocol $true

# If $SMB = 3 and OS = Server
Set-SmbServerConfiguration -enableSMB3Protocol $true

# Workstations
# If its a workstation, try the optionalfeatures
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol

# if $SMB = 2 and OS = Workstation
# Set-WindowsOptionalFeature -Online -FeatureName SMB2Protocol

# if $SMB = 3 and OS = Workstation
Set-WindowsOptionalFeature -Online -FeatureName SMB3Protocol

# Enable SMB signing as 'always'
Write-Host -ForegroundColor Green "Require SMB signingw Always"
$Parameters = @{
    RequireSecuritySignature = $True
    EnableSecuritySignature = $True
    EncryptData = $True
    Confirm = $false
}
Set-SmbServerConfiguration @Parameters