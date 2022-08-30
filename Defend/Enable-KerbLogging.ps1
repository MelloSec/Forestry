param(
    [Parameter(Mandatory = $false)]
    [string]$kerb = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos",
    [Parameter(Mandatory = $false)]
    [string]$param = "HKLM:\System\CurrentControlSet\Control\Lsa\Kerberos\Parameters"
)
$kerb = Get-ChildItem -Path $kerb | Select-Object Name
# Add the log level key for Kerberos logging
New-ItemProperty $param -Name "LogLevel" -value "1" -PropertyType dword
# Enable Kerberos logging
Set-ItemProperty $param -Name "LogLevel" -value "1"

# Disable Kerberos logging
# Set-ItemProperty $param -Name "LogLevel" -value "0"

