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

Refreshenv

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

# # DHCP

# Install-WindowsFeature DHCP -IncludeManagementTools
# Get-WindowsFeature -Name *DHCP*| Where Installed
# Add-DhcpServerInDC -DnsName dc1.mellosec.sunn -IPAddress 192.168.0.83
# Add-DhcpServerSecurityGroup
# Import-Module DHCPServer
# Get-DhcpServerInDC
# Get-DhcpServerv4Scope -ComputerName dc1