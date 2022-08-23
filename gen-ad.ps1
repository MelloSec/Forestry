param(
    [Parameter(Mandatory=$true)]$JSONFile
)

function Create-ADUSer {
    param( [Parameter(Mandatory=$true)]$UserObject )
    echo $UserObject


    # $User = New-Object -TypeName 'System.Security.Principal.WindowsPrincipal' -ArgumentList @($JSONFile)
    # $User.GetUnderlyingObject()
}

$json = ( Get-Content $JSONFile | ConvertFrom-Json )
foreach ( $user in $json.users ){
    Create-ADUser -UserObject $user
}
 