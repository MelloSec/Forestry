param(
    [Parameter(Mandatory=$true)]$JSONFile
)

function CreateADGroup(){
    $name = $groupObject.Name
    New-ADGroup -name $name -GroupScope Global

}

function Create-ADUSer(){
    param( [Parameter(Mandatory=$true)]$userObject )  
      # Name from JSON object, then create first name last name structure
      $name = $userObject.name
      $password = $userObject.password
      $firstname, $lastname = $name.split(" ")
      $username = ($firstname[0] + $lastname).ToLower()
      $samAccountName = $username
      $principalName = $username

      # Create the actual AD User Object 
      New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $samAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount 
  
      # Add user to approproate groups
      foreach($group_name in $userObject.groups){
        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "$username not added to group $group_name because it does not exist"
        }

      Add-ADGroupMember -Identity $group -Member $username
    }
}

# $json = ( Get-Content $JSONFile | ConvertFrom-Json )
$json = ( Get-Content $JSONFile | ConvertFrom-Json )

$Global:Domain = $json.domain

foreach ( $group in $json.groups ){
    Create-ADGroup $group
}

foreach ( $user in $json.users ){
    Create-ADUser -UserObject $user
}
 