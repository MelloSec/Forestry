function New-ADLabSMBShare{
    <#
    .SYNOPSIS
    Adds new share called hackme on the Domain controller and Share on workstation.
    .DESCRIPTION
    New-ADLabSMBShare configures a a share on both Domain Controller and workstation.
    .EXAMPLE
     New-ADLabSMBShare
    #> 
        [cmdletbinding()]
        param()
        
        if((Get-OSType) -eq 2)
        {
            try {
                $someerror = $true
                New-Item "C:\hackMe" -Type Directory -ErrorAction Stop
            }
            catch {
                Write-Warning "Unable to create hackme folder"
                
            }
            if($someerror)
            {
                try {
                    New-SmbShare -Name "hackMe" -Path "C:\hackMe" -ErrorAction Stop
                }
                catch {
                    Write-Warning "Unable to create Share"
                }
            }            
        }
        elseif ((Get-OSType) -eq 1) {
            try {
                $someerror = $true
                New-Item "C:\Share" -Type Directory -ErrorAction Stop
            }
            catch {
                Write-Warning "Unable to create hackme folder"
                $someerror = $false
                
            }
            if($someerror)
            {
                try {
                    New-SmbShare -Name "Share" -Path "C:\Share" -ErrorAction Stop
                }
                catch {
                    Write-Warning "Unable to create Share"
                }
            }    
        }
        else {
            Write-Warning "Invalid install. Exiting!!"
            exit        
        }            
    }