param(
    [Parameter(Mandatory=$true)]$JSONFile
)

function Create-ADUSer {
    param( [Parameter(Mandatory=$true)]$userObject )
      
    # Name from JSon object, then create first name last name structure
      $name = $userObject.name
      $password = $userObject.password
      $firstname, $lastname = $name.split(" ")
      $username = ($firstname[0] + $lastname).ToLower()
      $samAccountName = $username
      $principalName = $username

    New-ADUser -Name "$firstname $lastname" -GivenName $firstname -Surname $lastname -SamAccountName $samAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $generated_password -AsPlainText -Force) -PassThru | Enable-ADAccount 

   
    echo $UserObject

}

# $json = ( Get-Content $JSONFile | ConvertFrom-Json )
$json = $JSONFile | ConvertFrom-Json

$Global:Domain = $json.domain





foreach ( $user in $json.users ){
    Create-ADUser -UserObject $user
}
 