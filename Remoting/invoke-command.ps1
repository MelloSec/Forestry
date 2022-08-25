$Computer = Get-Content hosts.csv
if ($cred)
    { Write-Host "Variable already set" } else { $cred = (Get-Credential) }

$sessions = New-PSSession -ComputerName $Computer -Credential $cred
Invoke-Command -ComputerName $Computer -Credential $cred -ScriptBlock { hostname; net user; ipconfig; Echo "`r`n";Echo "`r`n";Echo "`r`n";Echo "`r`n";Echo "Next Host:";Echo "`r`n";Echo "`r`n" } 


#     function Invoke-Sessions {
#         param(
#             [Parameter(Mandatory=$true)]
#             [String]$cmd
#         )
# Invoke-Command -ComputerName $Computer -Credential $cred -ScriptBlock { $cmd }
# }

# Invoke-Sessions
