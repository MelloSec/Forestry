# Workstation
$Domain = 'mellosec.sunn'
$DC1 = '192.168.0.83'
$InterfaceIndex = (Get-NetAdapter).ifIndex
$CurrentIPv4Address = (Get-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4").IPAddress
Set-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4" -IPAddress "$CurrentIPv4Address" -PrefixLength 24 | Out-Null
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ("$DC1", "8.8.8.8")

. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter –Force
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Set-TimeZone -Name "Eastern Standard Time" -Verbose

Refreshenv

choco install -y --ignore-checksums git 
choco install -y --ignore-checksums poshgit 
choco install -y --ignore-checksums vscode 
choco install -y --ignore-checksums sysinternals 
choco install -y --ignore-checksums x64dbg.portable 
choco install -y --ignore-checksums ollydbg 
choco install -y --ignore-checksums ida-free 
choco install -y --ignore-checksums wireshark 
choco install -y --ignore-checksums reshack 
choco install -y --ignore-checksums processhacker
choco install -y --ignore-checksums autohotkey
choco install -y --ignore-checksums fiddler
choco install -y --ignore-checksums regshot
choco install -y --ignore-checksums dotpeek
choco install -y --ignore-checksums ghidra
choco install -y --ignore-checksums cutter 
choco install -y --ignore-checksums pestudio
choco install -y --ignore-checksums pebear
choco install -y --ignore-checksums pesieve
choco install -y --ignore-checksums hollowshunter
choco install -y --ignore-checksums dependencywalker  
choco install -y --ignore-checksums ilspy
choco install -y --ignore-checksums dnspy
choco install -y --ignore-checksums procmon
choco install -y --ignore-checksums fiddler
choco install -y --ignore-checksums regshot
choco install -y --ignore-checksums dnscrypt-proxy


# # ProcDot
# if(!(Test-Path 'C:\Tools')){ mkdir 'C:\Tools' }
# if(!(Test-Path 'C:\Tools\ProcDot')) { mkdir 'C:\Tools\ProcDot'; iwr -useb https://www.procdot.com/download/procdot/binaries/procdot_1_22_57_windows.zip -o 'C:\Tools\ProcDot\procdot.zip'; cd 'C:\Tools\ProcDot'}
# if(test-path .\ProcDot.zip) { Expand-Archive .\procdot.zip }

# house keeping
Disable-BingSearch
Set-TaskbarOptions -Dock Bottom
Set-ExplorerOptions -showHiddenFilesFoldersDrives -showFileExtensions
Enable-PSRemoting -Force
Update-Help
Enable-RemoteDesktop

function Install-Sysmon ($sysmonDir = 'C:\sysmon') {
    if(!(Test-Path -Path $sysmonDir)){
        $sysmonDir = mkdir $sysmonDir
    }
    Invoke-WebRequest -Uri "https://github.com/mellonaut/sysmon/raw/main/sysmon.zip" -OutFile "$sysmonDir\sysmon.zip"
    Expand-Archive "$sysmonDir\sysmon.zip" -DestinationPath $sysmonDir
    cd $sysmonDir
    .\sysmon.exe -acceptEula -i .\sysmonconfig.xml
}
Install-Sysmon

