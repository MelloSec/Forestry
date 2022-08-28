$group_names = [System.Collections.ArrayList](get-content "./data/group_names.txt")
$first_names = [System.Collections.ArrayList](get-content "./data/first_names.txt")
$last_names = [System.Collections.ArrayList](get-content "./data/last_names.txt")
$passwords = [System.Collections.ArrayList](get-content "./data/passwords.txt")

# Generate X groups from our list
$groups = @()
$num_groups = 10

for ( $i = 0; $i -lt $num_groups; $i++ ){
    $group_name = (Get-Random -InputObject $group_names) 
    $group = @{ "name" = "$group_name" }
    $groups += $group 
    $group_names.Remove($group_name)
}

echo $groups

# Generate X users in groups from our list
$users = @()
$num_users = 80

for ( $i = 0; $i -lt $num_users; $i++ ){
    $first_name = (Get-Random -InputObject $first_names)
    $last_name = (Get-Random -InputObject $last_names)
    $password = (Get-Random -InputObject $passwords)
    $new_user= @{
        FirstName = $first_name
        LastName = $last_name
        Password = $password
        Groups = @((Get-Random -InputObject $groups))
    }
    echo $new_user
    $first_names.Remove($first_name)
    $last_names.Remove($last_name)
    $passwords.Remove($password)
}

echo @{         
        "domain" = "mellosec.sunn"
        "users" = $users
        "groups" = $groups
}


