$group = 'Servers' 
$servers = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' ` -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address | Sort-Object -Property Operatingsystem | Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address 


foreach ($server in $servers) {
    $obj = Get-ADComputer $server
    Add-ADGroupMember -ID $group -Members $obj
}