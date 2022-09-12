$roleUsers = @() 
$roles=Get-AzureADMSGroup
 
ForEach($role in $roles) {
  $users=Get-AzureADGroupMember -ObjectId $role.Id
  ForEach($user in $users) {
    write-host $role.DisplayName, $user.DisplayName, $user.UserPrincipalName, $user.UserType
    $obj = New-Object PSCustomObject
    $obj | Add-Member -type NoteProperty -name GroupName -value ""
    $obj | Add-Member -type NoteProperty -name UserDisplayName -value ""
    $obj | Add-Member -type NoteProperty -name UserEmailID -value ""
    $obj | Add-Member -type NoteProperty -name UserAccess -value ""
    $obj.GroupName=$role.DisplayName
    $obj.UserDisplayName=$user.DisplayName
    $obj.UserEmailID=$user.UserPrincipalName
    $obj.UserAccess=$user.UserType
    $roleUsers+=$obj
  }
}
$roleUsers