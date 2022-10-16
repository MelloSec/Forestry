# set-item wsman:\localhost\Client\TrustedHosts -Value *
param(
    [Parameter(Mandatory=$true)]
    [string]$script
)
$Computers = Get-Content .\local.txt 
if ($cred){ Write-Host "Variable already set" } else { $cred = (Get-Credential) }
$local = New-PSSession -ComputerName $Computers -Credential $cred
# Enter-PsSession $local
Invoke-Command -ComputerName $Computers -Credential $cred -Filepath $script

