# AppServer

$Domain = 'mellosec.sunn'
$DC1 = '192.168.0.83'
$User = 'Administrator'
$DomName = 'mellosec'
$Pass = 'Password123' 
$InterfaceIndex = (Get-NetAdapter).ifIndex
# $CurrentIPv4Address = (Get-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4").IPAddress
# Remove-NetIpAddress -InterfaceIndex $InterfaceIndex -IPAddress $CurrentIPv4Address
# Set-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4" -IPAddress "$CurrentIPv4Address" -PrefixLength 24 | Out-Null

# Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses "$DC1","8.8.8.8"
# # Add-Computer -DomainName $Domain -Credential mellosec\Administrator -Restart -Force

# . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# Set-TimeZone -Name "Eastern Standard Time" -Verbose



# # house keeping
# Disable-BingSearch
# Set-TaskbarOptions -Dock Bottom
# Set-ExplorerOptions -showHiddenFilesFoldersDrives -showFileExtensions
# Enable-PSRemoting -Force
# Update-Help
# Enable-RemoteDesktop

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
if(!(get-module -ListAvailable -name ActiveDirectory)){ Install-Module ActiveDirectory }
Import-Module -Name ActiveDirectory

# Install as a DC
Install-ADDSDomainController -DomainName $DomainName -InstallDns:$true -Credential (Get-Credential "mellosec\administrator")


# Create anonymous Share 
function Create-PublicShare {
	mkdir "C:\Reports"
	New-SmbShare -Name Common -Path "C:\Reports" -FullAccess Everyone
	Enable-LocalUser -Name "Guest"
	$acl = Get-Acl "C:\Reports"
	$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Guest","FullControl","Allow")
	$acl.SetAccessRule($AccessRule)
	$acl | Set-Acl "C:\Reports"
	Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'EveryoneIncludesAnonymous' -value '1'
	New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -name "NullSessionShares" -PropertyType MultiString -value ""C:\Reports""
}
Create-PublicShare

# Set anonymous LDAP access
function Allow-OpenLDAP {
	$Dcname = Get-ADDomain | Select-Object -ExpandProperty DistinguishedName
	$Adsi = 'LDAP://CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,' + $Dcname
	$AnonADSI = [ADSI]$Adsi
	$AnonADSI.Put("dSHeuristics","0000002")
	$AnonADSI.SetInfo()
	$ADSI = [ADSI]('LDAP://CN=Users,' + $Dcname)
	$Anon = New-Object System.Security.Principal.NTAccount("ANONYMOUS LOGON")
	$SID = $Anon.Translate([System.Security.Principal.SecurityIdentifier])
	$adRights = [System.DirectoryServices.ActiveDirectoryRights] "GenericRead"
	$type = [System.Security.AccessControl.AccessControlType] "Allow"
	$inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
	$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $SID,$adRights,$type,$inheritanceType
	$ADSI.PSBase.ObjectSecurity.ModifyAccessRule([System.Security.AccessControl.AccessControlModification]::Add,$ace,[ref]$false)
	$ADSI.PSBase.CommitChanges()
}
Allow-OpenLDAP



# Print services
Install-WindowsFeature Print-Service

# TODO automate vulnerable ADCS

# SQL
choco install sql-server-2016 -y --ignore-checksums
# choco install sql-server-2016 -Y --force --params="/SQLSYSADMINACCOUNTS:$DomName\$user /SECURITYMODE:SQL /SAPWD:$Pass /IgnorePendingReboot /INSTANCENAME:SQL1 /INSTANCEDIR:c:\MSSQL\SQL1"

# IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools





# Turn into a Windows Event Collector
wecutil qc -quiet

# Increase log cache to 1 GB
wevtutil sl forwardedevents /ms:1000000000

# Install winlogbeats
choco install -y winlogbeat