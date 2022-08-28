param(
    [Parameter]
    [string]$name
)
New-ADOrganizationalUnit -Name $name -Path "DC=MELLOSEC,DC=SUNN" 