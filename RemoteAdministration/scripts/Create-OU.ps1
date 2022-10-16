param(
    [Parameter]
    [string]$name
)
New-ADOrganizationalUnit -Name $name -Path "DC=MELLOSEC,DC=SUNN"
# New-ADGroup -Name $name -SamAccountName $name -GroupCategory Security -GroupScope Global -DisplayName "$name" -Path "CN=Users,DC=Mellosec,DC=sunn" -Description "Members of this group can access $name"
