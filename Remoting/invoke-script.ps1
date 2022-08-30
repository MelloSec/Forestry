param(
    [Parameter(Mandatory = $false)]
    [string]$script = "./scripts/tester.ps1",
    [Parameter(Mandatory = $false)]
    [string]$Computer = "192.168.0.83"
    # [string]$Computer = (Get-Content "./servers.csv")
)
if ($cred)
    { Write-Host "Variable already set" } else { $cred = (Get-Credential) }

$sessions = Get-PSSession -ComputerName $Computer -Credential $cred | Connect-PsSession
Invoke-Command -ComputerName $Computer -Credential $cred -Filepath $script