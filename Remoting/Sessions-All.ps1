# Create sessions on all our hosts in domain
if ($cred){ Write-Host "Variable already set" } else { $cred = (Get-Credential) }
$hosts = Get-Content ./hosts.csv
$sessions = New-PSSession -ComputerName $hosts -Credential $cred

