# set-item wsman:\localhost\Client\TrustedHosts -Value *
$DC1 = New-PSSession -ComputerName 192.168.0.83 -Credential Administrator
Enter-PsSession $DC1
