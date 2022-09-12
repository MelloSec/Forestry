param(
    [string]$ip,
    [string]$hostname
)
$ip = '192.168.100.138'
$hostname = 'holo.live'

$file = "C:\windows\System32\drivers\etc\hosts"
$hostfile = Get-Content $file
$hostfile += "$ip   $hostname"
Set-Content -Path $file -Value $hostfile -Force