# Forestry


## PSRemoting reference:

Copy-Item .\ad_schema.json -ToSession $DC1 C:\Windows\Tasks

$DC1 = New-PSSession -ComputerName 192.168.0.83 -Credential (get-Credential)
$s1 = Enter-PsSession $DC1



# AD Schema reference
$JSONFile =  Get-Content .\ad_schema.json
