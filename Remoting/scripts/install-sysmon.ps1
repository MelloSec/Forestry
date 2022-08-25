# Check if sysmon is installed on our preffered path, retry any failed downloads and install if we have the zip with our config
function Grab-Sysmon {
    Invoke-WebRequest -Uri 'https://github.com/mellonaut/sysmon/raw/main/sysmon.zip' -OutFile 'C:\sysmon\sysmon.zip'
}
if(!(test-path 'C:\sysmon')) { mkdir 'C:\sysmon'}
if(!(test-path 'C:\sysmon\sysmon.zip')) { echo 'Download failed'; Grab-Sysmon }
if(test-path 'C:\sysmon\sysmon.zip') { echo 'Download succeeded'; Expand-Archive 'c:\sysmon\sysmon.zip' -DestinationPath "C:\sysmon" }
cd 'c:\sysmon'
c:\sysmon\sysmon.exe -acceptEula -i 'c:\sysmon\sysmonconfig.xml'