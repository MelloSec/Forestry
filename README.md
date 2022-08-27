# Forestry


## PSRemoting reference:


$cred = (Get-Credential)
$DC1 = New-PSSession -ComputerName 192.168.0.83 -Credential $cred
Enter-PsSession $DC1

$pc = New-PsSession -ComputerName 192.168.0.69 -Credential $cred


Copy-Item .\ad_schema.json -ToSession $DC1 C:\Windows\Tasks
Copy-Item ../Forestry -ToSession $DC1 C:\scripts

$DC1 = New-PSSession -ComputerName 192.168.0.83 -Credential (get-Credential)
Enter-PsSession $DC1

# Install Zerotier on a host and join our network
$zt = NetworkId
.\invoke-script.ps1 -script -Computer $Computer ..\Borrowed\InstallZeroTier.ps1 


# AD Schema reference
$JSONFile =  Get-Content .\ad_schema.json
