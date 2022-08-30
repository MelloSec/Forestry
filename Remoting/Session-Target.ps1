param(
    [Parameter(Mandatory = $false)]
    [string]$host
)
if ($cred){ Write-Host "Variable already set" } else { $cred = (Get-Credential) }
$sess = New-PSSession -ComputerName $host -Credential $cred
Enter-PsSession $sess
