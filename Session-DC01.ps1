# set-item wsman:\localhost\Client\TrustedHosts -Value *
$DC1 = New-PSSession -ComputerName 192.168.0.83 -Credential (get-Credential)
Enter-PsSession $DC1
