# Example of using Nmap ldap script to enumerate domain as long as we have one valid user/pass

nmap -p 389 --script ldap-search \
--script-args \
'ldap.username="CN=Administrator,CN=Users,DC=mellosec,DC=sunn", \
ldap.password="Password123", \
ldap.qfilter=computers' \
192.168.0.83