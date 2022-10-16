$group = 'Workstations' 
$workstations = Get-ADComputer -Filter 'operatingsystem -like "*windows 10*" -and enabled -eq "true"' ` -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address | Sort-Object -Property Operatingsystem | Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address 


foreach ($w in $workstations) {
    $obj = Get-ADComputer $w
    Add-ADGroupMember -ID $group -Members $obj
}