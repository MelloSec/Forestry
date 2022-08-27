param(
    $service = "Fuel DB",
    $SAM = "Fleet",
    $hostname = "dc01.mellosec.sunn",
    $port = "80"
)

New-ADuser -Name $service -SamAccountName $SAM -Enabled $true -AccountPassword (ConvertTo-SecureString -String "Password123!" -AsPlainText -Force)
setspn -A $SAM/$hostname:80 $SAM
setspn -Q */* | findstr $SAM

# create a fake service account for a real user
setspn -A TEST/test $SAM