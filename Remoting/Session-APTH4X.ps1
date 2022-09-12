# set-item wsman:\localhost\Client\TrustedHosts -Value *
if ($cred){ Write-Host "Variable already set" } else { $cred = (Get-Credential) }
$apt = New-PSSession -ComputerName 192.168.0.210 -Credential $cred
Enter-PsSession $apt
