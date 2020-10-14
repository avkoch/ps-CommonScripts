# RunAs block. (c) Ben Armstrong (https://docs.microsoft.com/ru-ru/archive/blogs/virtual_pc_guy/a-self-elevating-powershell-script)

# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
# Get the security principal for the Administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole)) {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (ELEVATED)"
    $Host.UI.RawUI.BackgroundColor = "Black"
    Clear-Host
}
else {
    # We are not running "as Administrator" - so relaunch as administrator
    # Create a new process object that starts PowerShell
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition
    # Indicate that the process should be elevated
    $newProcess.Verb = "runas"
    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess) | Out-Null
    # Exit from the current, unelevated, process
    exit
}