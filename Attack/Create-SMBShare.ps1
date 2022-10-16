function Create-PublicShare {
    param(
        [string]$ShareName = "Trusting",
        [string]$SharePath = "C:\Trusting",
        [string]$ShareUser = "Guest"
    )
    
	mkdir $SharePath
	New-SmbShare -Name $ShareName -Path $SharePath -FullAccess Everyone
	Enable-LocalUser -Name "Guest"
	$acl = Get-Acl $SharePath
	$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Guest","FullControl","Allow")
	$acl.SetAccessRule($AccessRule)
	$acl | Set-Acl $SharePath
	Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'EveryoneIncludesAnonymous' -value '1'
	New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -name "NullSessionShares" -PropertyType MultiString -value ""$ShareName""
}
Create-PublicShare