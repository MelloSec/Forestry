# Create sessions on all our hosts in domain
if ($cred){ Write-Host "Variable already set" } else { $cred = (Get-Credential) }
$hosts = Get-Content ./hosts.csv
New-PSSession -ComputerName $hosts -Credential $cred
$sessions = Get-Pssession
$sessions
