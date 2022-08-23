set-item wsman:\localhost\Client\TrustedHosts -Value *
$DC1 = New-PSSession -ComputerName 192.168.0.83 -Credential (get-Credential)
Enter-PsSession $DC1


# on DC, set Static IP, DNS
$Domain = 'MelloSec.sunn'
$NetworkID = '192.168.0.1'
$NewIPv4DNSServer = "8.8.8.8"
$ZoneFile = '192.168.0.83.in-addr.arpa.dns' 
$InterfaceIndex = (Get-NetAdapter).ifIndex
$CurrentIPv4Address = (Get-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4").IPAddress
Set-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4" -IPAddress "$CurrentIPv4Address" -PrefixLength 24 | Out-Null
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ("127.0.0.1", "$NewIPv4DNSServer")



$DSRMPassword = 'Password123!'

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





# multiple servers
# $s1, $s2, $s3 = New-PSSession -ComputerName Server01,Server02,Server03

# Write-Verbose "Installing DNS feature..."

# Install-WindowsFeature DNS -IncludeManagementTools
# Remove-WindowsFeature DNS -IncludeManagementTools

# Write-Verbose "Configuring primary zone..."

# Add-DnsServerPrimaryZone -NetworkID $NetworkID -ZoneFile $ZoneFile

# Write-Verbose "Adding Server Forwarder..."

# Add-DnsServerForwarder -IPAddress $CurrentIPv4Address -PassThru