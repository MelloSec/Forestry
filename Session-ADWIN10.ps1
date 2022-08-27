# set-item wsman:\localhost\Client\TrustedHosts -Value *
if ($cred){ Write-Host "Variable already set" } else { $cred = (Get-Credential) }
$win10 = New-PSSession -ComputerName 192.168.0.69 -Credential $cred
Enter-PsSession $win10
