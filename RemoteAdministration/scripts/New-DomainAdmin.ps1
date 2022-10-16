param(
    [Parameter(Mandatory=$false)]
    [string]$user,
    [Parameter(Mandatory=$false)]
    [string]$group = "Domain Admins"
)

$cred = Read-Host -AsSecureString
New-ADUSer -Name $user -AccountPassword $cred -PasswordNeverExpires $true -enabled $true; Add-ADGroupMember -Identity $group -Members $user