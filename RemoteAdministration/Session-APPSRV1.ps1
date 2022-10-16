# set-item wsman:\localhost\Client\TrustedHosts -Value *
if($cred){ Write-Host "Variable already set" }else{ $cred = (Get-Credential) }
$app1 = New-PSSession -ComputerName 192.168.0.200 -Credential $cred
Enter-PsSession $app1
