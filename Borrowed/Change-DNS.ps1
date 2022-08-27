Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer | ? {$_.IPEnabled }

#### TO #####


Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer | ? {$_.IPEnabled -and $_.DNSServerSearchOrder -like "*192.168.2.6*" -or $_.DNSServerSearchOrder -like "*10.215.0.4*"}


#######################################################>

    If ( ! (Get-module ActiveDirectory )) {
  Import-Module ActiveDirectory
  Cls
  }
  $computers=Get-ADComputer -Filter {Operatingsystem -like '*server*'} | Select -ExpandProperty dnshostname
  $data=Foreach($computer in $computers)
  {if(!(Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))
  {write-host "cannot reach $computer" -f red}
  Else {
  TRY{
  $ErrorActionPreference = "Stop"
  Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer | 
  where {$_.IPEnabled }|select @{n='ComputerName';e={$Computer}},@{n='DnsEntries';e = {$_.DNSServerSearchOrder -join ','}},@{n='DHCPEnabled';e={ $_.DHCPEnabled}}
  
  }
  
   Catch{
   Write-Host "$($computer) " -BackgroundColor red -NoNewline
   Write-Warning $Error[0] 
    }
    }
    }

    $data|Export-csv c:\DNSentries.csv -NoTypeInformation

###To Modify DNS

$computers = import-csv c:\dnsentries.csv |select -exp computername
Foreach($COMPUTER in $computers){
TRY{
  $ErrorActionPreference = "Stop"
$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $computer |where{$_.IPEnabled -eq “TRUE” <# -and $_.DHCPEnabled -ne 'True'  #>}
  Foreach($NIC in $NICs) {
$DNSServers = “8.8.8.8",”192.168.40.119" ## the new DNS entries
 $NIC.SetDNSServerSearchOrder($DNSServers)  | Out-Null
 $NIC.SetDynamicDNSRegistration(“TRUE”)  | Out-Null
 Write-Host "Successfully set on $computer" -f green
}
}

Catch{
   Write-Host "$($computer) " -BackgroundColor red -NoNewline
   Write-Warning $Error[0] 
    }
    }

## Remove static IP and enable DHCP
##Csv shold contain header as computername

$computers = import-csv c:\list.csv |select -exp computername
#Or you can even#> $computers=Get-ADComputer -Filter {Operatingsystem -like '*windows 10*' -or Operatingsystem -like '*windows 7*} | Select -ExpandProperty dnshostname
#>
Foreach($COMPUTER in $computers){
TRY{
  $ErrorActionPreference = "Stop"
$nics=Get-WmiObject Win32_NetworkAdapterConfiguration  -ComputerName $computer|where {$_.IPEnabled -and $_.DHCPEnabled -eq $false} 
Foreach($NIC in $NICs) { 
$NIC.EnableDHCP() |Out-Null
$NIC.SetDNSServerSearchOrder() |Out-Null
}
 Write-Host "Successfully set DHCP on $computer" -f green
}


Catch{
   Write-Host "$($computer) " -BackgroundColor red -NoNewline
   Write-Warning $Error[0] 
    }
    }
    