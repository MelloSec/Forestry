$cred = (Get-Credential)
$hosts = Get-Content ./hosts.csv
$sessions = New-PSSession -ComputerName $hosts -Credential $cred

