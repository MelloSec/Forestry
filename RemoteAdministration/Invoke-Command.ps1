param(
    [Parameter(Mandatory = $false)]
    [string]$cmd = "hostname; net user; ipconfig",
    [Parameter(Mandatory = $false)]
    [string]$Computer = "192.168.0.83"
)

# $Computer = Get-Content hosts.csv
if ($cred)
    { Write-Host "Variable already set" } else { $cred = (Get-Credential) }

$sessions = Get-PSSession -ComputerName $Computer -Credential $cred | Connect-PsSession
Invoke-Command -ComputerName $Computer -Credential $cred -ScriptBlock { $cmd } 
# $Workstation = $sessions[0]

# If statement for if the sessions returned contain a workstation we run this script for
# if($Workstation.ComputerName.ToString() = '192.168.0.69') { .\scripts\Remote-Install.ps1 } 



#     function Invoke-Sessions {
#         param(
#             [Parameter(Mandatory=$true)]
#             [String]$cmd
#         )
# Invoke-Command -ComputerName $Computer -Credential $cred -ScriptBlock { $cmd }
# }

# Invoke-Sessions
