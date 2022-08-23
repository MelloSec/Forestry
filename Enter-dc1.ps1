# set-item wsman:\localhost\Client\TrustedHosts -Value *
$DC1 = New-PSSession -ComputerName 192.168.0.83 -Credential (get-Credential)
$s1 = Enter-PsSession $DC1
