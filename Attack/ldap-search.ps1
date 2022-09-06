# Examples of using Nmap ldap script to enumerate domain as long as we have one valid user/pass
# This is using the admin account, so we can extract LAPS passwords but this can be used with a standard user to begin privesc

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


# Computers with details, saved to CSV
nmap -p 389 --script ldap-search \
--script-args \
'ldap.username="CN=Administrator,CN=Users,DC=mellosec,DC=sunn", \
ldap.password="Password123", \
ldap.qfilter=computers, \
ldap.attrib={name,dNSHostName}, \
ldap.savesearch=test' 192.168.0.83

# Extract LAPS passwords and save in CSV
nmap -p 389 --script ldap-search \
--script-args \
'ldap.username="CN=Administrator,CN=Users,DC=mellosec,DC=sunn", \
ldap.password="Password123", \
ldap.qfilter=computers, \
ldap.attrib=ms-Mcs-AdmPwd, \
ldap.savesearch=LAPS' \ 192.168.0.83
