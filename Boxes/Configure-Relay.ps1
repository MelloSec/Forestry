choco install git -y --ignore-checksums
choco install poshgit -y --ignore-checksums
choco install vscode -y --ignore-checksums
choco install x64dbg.portable -y --ignore-checksums
choco install sysinternals -y --ignore-checksums
choco install procmon -y --ignore-checksums
choco install procdot -y --ignore-checksums
choco install processhacker -y --ignore-checksums
choco install zerotier-one -y --ignore-checksums
choco install sql-server-2019 -y --ignore-checksums

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


# Disable SMB Signing
Set-SmbClientConfiguration -RequireSecuritySignature 0 -EnableSecuritySignature 0 -Confirm -Force

# IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools

function Create-PublicShare {
	mkdir "C:\FieldUsers"
	New-SmbShare -Name 'FieldUsers' -Path "C:\FieldUsers" -FullAccess Everyone
	Enable-LocalUser -Name "Guest"
	$acl = Get-Acl "C:\FieldUsers"
	$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Guest","FullControl","Allow")
	$acl.SetAccessRule($AccessRule)
	$acl | Set-Acl "C:\FieldUsers"
	Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'EveryoneIncludesAnonymous' -value '1'
	New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -name "NullSessionShares" -PropertyType MultiString -value ""C:\FieldUsers""
}
Create-PublicShare

# Enable WINRM
# function Enable-WinRM {
# 	Enable-PSRemoting -Force
# 	Set-Item wsman:\localhost\client\trustedhosts * -Force
# 	#(Get-PSSessionConfiguration -Name "Microsoft.PowerShell").SecurityDescriptorSDDL
# 	Set-PSSessionConfiguration -Name "Microsoft.PowerShell" -SecurityDescriptorSddl "O:NSG:BAD:P(A;;GA;;;BA)(A;;GA;;;WD)(A;;GA;;;IU)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)"
# }
# Enable-WinRM

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

