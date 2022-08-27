param(
    [Parameter(Mandatory = $false)]
    [string]$script = "./scripts/tester.ps1",
    [Parameter(Mandatory = $false)]
    [string]$Computer = "192.168.0.83"
)
if ($cred)
    { Write-Host "Variable already set" } else { $cred = (Get-Credential) }

$sessions = New-PSSession -ComputerName $Computer -Credential $cred
Invoke-Command -ComputerName $Computer -Credential $cred -Filepath $script