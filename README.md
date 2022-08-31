# Forestry

Inspired by John Hammond's AD series on youtube and using his method of generating the schema with a json file. 

An Active Directory lab to practice remote administration and penetration testing TTPs

Setup scripts for each server and workstation are in the boxes folder. They use boxstarter and chocolately to install some debug tools and features, then configure roles in the domain. Ideally, get your base VMs alive in VMware/Virtualbox (if ya nasty) and enable PSremoting, then use Invoke-Command with the script to run the scripts on each host




set-item wsman:\localhost\Client\TrustedHosts -Value <IP of computers>
You can set it to * if you aren't worried about trusting all hosts


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

# Check Event logs for kerbrute attack
# HAve to enable Kerberos Error logging first

Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 4768 }
