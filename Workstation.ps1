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

choco install git -y
choco install poshgit -y
choco install vscode -y
choco install sysinternals -y
choco install x64dbg.portable -y
choco install ollydbg -y
choco install ida-free -y
choco install wireshark -y
choco install reshack -y
choco install -y processhacker
choco install -y autohotkey
choco install -y fiddler
choco install -y regshot
choco install -y dotpeek
choco install -y ghidra
choco install -y cutter 
choco install -y pestudio
choco install -y pebear
choco install -y pesieve
choco install -y hollowshunter
choco install -y dependencywalker  
choco install -y ilspy
choco install -y dnspy
choco install -y procmon
choco install -y procdot
choco install -y fiddler
choco install -y regshot
choco install -y dnscrypt-proxy

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

