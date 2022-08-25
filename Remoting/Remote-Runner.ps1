$dnsserver = (,"10.215.0.19","10.215.0.4")

# $Computer = Get-ADComputer -Filter "OperatingSystem -like '*windows 10*'"

$Computer = Get-Content hosts.csv
$cred = (Get-Credential)
$sessions = New-PSSession -ComputerName $Computer -Credential $cred
Invoke-Command -ComputerName $Computer -Credential $cred -ScriptBlock { hostname }
Invoke-Command -ComputerName $Computer -Credential $cred -FilePath change-dns.ps1

w
# DNS
# foreach ($i in $Computer) {Get-WmiObject -Class Win32_NetworkAdapterConfiguration -computername $i -Filter IPEnabled=TRUE | Invoke-WmiMethod -Name SetDNSServerSearchOrder -ArgumentList (,$dnsserver)
# ;}

# Disable LLMNR and NTBDNS

# Force SMB Signing

# Install sysmon

# Force Windows update