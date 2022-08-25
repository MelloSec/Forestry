# This will serve as script to run configuration remotely with PSRemoting





# Domain Controller
$Domain = 'MelloSec.sunn'
$DSRMPassword = 'Password123!'
$NetworkID = '192.168.0.1'
$NewIPv4DNSServer = "8.8.8.8"
$InterfaceIndex = (Get-NetAdapter).ifIndex
$CurrentIPv4Address = (Get-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4").IPAddress
Remove-NetIpAddress -InterfaceIndex $InterfaceIndex -IPAddress $CurrentIPv4Address
Set-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4" -IPAddress "$CurrentIPv4Address" -PrefixLength 24 | Out-Null
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ("127.0.0.1", "$NewIPv4DNSServer")

Write-Verbose "Installing AD DS feature..."

Install-WindowsFeature -Name "AD-Domain-Services" -IncludeManagementTools


Write-Verbose "Installing new forest: $Domain"
    
$Password = ConvertTo-SecureString -AsPlainText -String $DSRMPassword -Force
$NetbiosName = $Domain.split(".")[0].ToUpper()

Install-ADDSForest -DomainName "$Domain" -DomainNetbiosName "$NetbiosName" -SafeModeAdministratorPassword $Password -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -LogPath "C:\Windows\NTDS" -DomainMode "WinThreshold" -ForestMode "WinThreshold" -NoRebootOnCompletion:$false -InstallDNS:$false -Force:$true

# Install boxstarter with chocolatey and basic configuration
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter –Force
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Set-TimeZone -Name "Eastern Standard Time" -Verbose

choco install -y git
choco install -y poshgit
choco install sublimetext4 -y
choco install sysinternals -y

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



Install-ADDSForest -DomainName mellosec.sunn -InstallDNs




# Workstation

$Domain = 'mellosec.sunn'
$DC1 = '192.168.0.83'
$InterfaceIndex = (Get-NetAdapter).ifIndex
$CurrentIPv4Address = (Get-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4").IPAddress
Set-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4" -IPAddress "$CurrentIPv4Address" -PrefixLength 24 | Out-Null
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ("$DC1", "8.8.8.8")

. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter –Force
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Set-TimeZone -Name "Eastern Standard Time" -Verbose

choco install git -y
choco install poshgit -y
choco install vscode -y
choco install sysinternals -y
choco install x64dbg.portable -y
choco install ollydbg -y
choco install ida-free -y
choco install wireshark -y
choco install reshack -y
choco install -y processhacker
choco install -y autohotkey
choco install -y fiddler
choco install -y regshot
choco install -y dotpeek
choco install -y ghidra
choco install -y cutter 
choco install -y pestudio
choco install -y pebear
choco install -y pesieve
choco install -y hollowshunter
choco install -y dependencywalker  
choco install -y ilspy
choco install -y dnspy
choco install -y procmon
choco install -y procdot
choco install -y fiddler
choco install -y regshot
choco install -y dnscrypt-proxy

# house keeping
Disable-BingSearch
Set-TaskbarOptions -Dock Bottom
Set-ExplorerOptions -showHiddenFilesFoldersDrives -showFileExtensions
Enable-PSRemoting -Force
Update-Help
Enable-RemoteDesktop



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




# AppServer

$Domain = 'mellosec.sunn'
$DC1 = '192.168.0.83'
$InterfaceIndex = (Get-NetAdapter).ifIndex
$CurrentIPv4Address = (Get-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4").IPAddress
Remove-NetIpAddress -InterfaceIndex $InterfaceIndex -IPAddress $CurrentIPv4Address
Set-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4" -IPAddress "$CurrentIPv4Address" -PrefixLength 24 | Out-Null

Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses "$DC1","8.8.8.8"
Add-Computer -DomainName $Domain -Credential mellosec\Administrator -Restart -Force

. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter –Force
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Set-TimeZone -Name "Eastern Standard Time" -Verbose

# house keeping
Disable-BingSearch
Set-TaskbarOptions -Dock Bottom
Set-ExplorerOptions -showHiddenFilesFoldersDrives -showFileExtensions
Enable-PSRemoting -Force
Update-Help
Enable-RemoteDesktop

choco install git -y
choco install poshgit -y
choco install vscode -y
choco install x64dbg.portable -y
choco install sysinternals -y
choco install procmon -y
choco install procdot -y
choco install processhacker -y

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





# multiple servers
# $s1, $s2, $s3 = New-PSSession -ComputerName Server01,Server02,Server03

# Write-Verbose "Installing DNS feature..."

# Install-WindowsFeature DNS -IncludeManagementTools
# Remove-WindowsFeature DNS -IncludeManagementTools

# Write-Verbose "Configuring primary zone..."

# Add-DnsServerPrimaryZone -NetworkID $NetworkID -ZoneFile $ZoneFile

# Write-Verbose "Adding Server Forwarder..."

# Add-DnsServerForwarder -IPAddress $CurrentIPv4Address -PassThru