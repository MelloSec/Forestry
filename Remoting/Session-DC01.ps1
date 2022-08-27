# set-item wsman:\localhost\Client\TrustedHosts -Value *
if ($cred){ Write-Host "Variable already set" } else { $cred = (Get-Credential) }
$DC1 = New-PSSession -ComputerName 192.168.0.83 -Credential Administrator
Enter-PsSession $DC1
