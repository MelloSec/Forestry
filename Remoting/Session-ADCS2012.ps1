# set-item wsman:\localhost\Client\TrustedHosts -Value *
if ($cred){ Write-Host "Variable already set" } else { $cred = (Get-Credential) }
$acc = New-PSSession -ComputerName 192.168.0.212 -Credential $cred
Enter-PsSession $acc
