# AppServer

$Domain = 'mellosec.sunn'
$DC1 = '192.168.0.83'
$User = 'Administrator'
$DomName = 'mellosec'
$Pass = 'Password123' 
$InterfaceIndex = (Get-NetAdapter).ifIndex
$CurrentIPv4Address = (Get-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4").IPAddress
Remove-NetIpAddress -InterfaceIndex $InterfaceIndex -IPAddress $CurrentIPv4Address
Set-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4" -IPAddress "$CurrentIPv4Address" -PrefixLength 24 | Out-Null

Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses "$DC1","8.8.8.8"
Add-Computer -DomainName $Domain -Credential mellosec\Administrator -Restart -Force

. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter –Force
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Set-TimeZone -Name "Eastern Standard Time" -Verbose

Refreshenv

# house keeping
Disable-BingSearch
Set-TaskbarOptions -Dock Bottom
Set-ExplorerOptions -showHiddenFilesFoldersDrives -showFileExtensions
Enable-PSRemoting -Force
Update-Help
Enable-RemoteDesktop

choco install git -y --ignore-checksums
choco install poshgit -y --ignore-checksums
choco install vscode -y --ignore-checksums
choco install x64dbg.portable -y --ignore-checksums
choco install sysinternals -y --ignore-checksums
choco install procmon -y --ignore-checksums
choco install procdot -y --ignore-checksums
choco install processhacker -y --ignore-checksums
choco install zerotier-one -y --ignore-checksums

function Install-Sysmon ($sysmonDir = 'C:\sysmon') {
    if(!(Test-Path -Path $sysmonDir)){
        $sysmonDir = mkdir $sysmonDir
    }
    Invoke-WebRequest -Uri "https://github.com/mellonaut/sysmon/raw/main/sysmon.zip" -OutFile "$sysmonDir\sysmon.zip"
    Expand-Archive "$sysmonDir\sysmon.zip" -DestinationPath $sysmonDir
    cd $sysmonDir
    .\sysmon.exe -acceptEula -i .\sysmonconfig.xml
}
Install-Sysmon

# Promote DC after primary is up

# Install Features
$DomainName = "mellosec.sunn"
Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools

# Get the module if it doesnt install by default
if(!(get-module -ListAvailable -name ActiveDirectory){ Install-Module ActiveDirectory }
Import-Module -Name ActiveDirectory

# Install as a DC
Install-ADDSDomainController -DomainName $DomainName -InstallDns:$true -Credential (Get-Credential "mellosec\administrator")


# SQL 2019

choco install sql-server-2019 -Y --force --params="/SQLSYSADMINACCOUNTS:$DomName\$user /SECURITYMODE:SQL /SAPWD:$Pass /IgnorePendingReboot /INSTANCENAME:SQL1 /INSTANCEDIR:c:\MSSQL\SQL1"

# Turn into a Windows Event Collector
wecutil qc -quiet

# Increase log cache to 1 GB
wevtutil sl forwardedevents /ms:1000000000

# Install winlogbeats
choco install -y winlogbeat