# Run the unregister command remotely
dsregcmd /leave

# Check status for AzureADJoined : NO
dsregcmd /status -NoNewWindow
Write-Host "Ensure that the AzureADJoined status is NO and DomainJoined is YES before pressing any key to proceed"
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

