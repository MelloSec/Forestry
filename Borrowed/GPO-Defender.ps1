function New-ADLabAVGroupPolicy{
    <#
    .SYNOPSIS
    Adds new group policy to disable windows defender.
    .DESCRIPTION
    New-ADLabAVGroupPolicy configures a new group policy to disable windows defender.
    .EXAMPLE
     New-ADLabAVGroupPolicy
    #> 
        [cmdletbinding()]
        param()
    
        if((Get-OSType) -ne 2)
        {
            Write-Host "Domain Controller not detected. Exiting!!" -BackgroundColor Yellow -ForegroundColor Black
            exit
                    
        }
        
        try {
            $someerror = $true
            New-GPO -Name "Disable Windows Defender" -Comment "This policy disables windows defender" -ErrorAction Stop
        }
        catch {
            $someerror = $false
            Write-Warning "Unable to create the Policy."
            
        }
        
        if($someerror)
        {
            Set-GPRegistryValue -Name "Disable Windows Defender" -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" -ValueName "DisableAntiSpyware" -Type DWord -Value 1
            Set-GPRegistryValue -Name "Disable Windows Defender" -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -ValueName "DisableRealtimeMonitoring" -Type DWord -Value 1                
            New-GPLink -Name "Disable Windows Defender" -Target ((Get-ADDomain).DistinguishedName)
        }
    
    }