<#
.SYNOPSIS
Show computer uptime
.DESCRIPTION
Show computer uptime as a string
.EXAMPLE
#.\Get-Uptime.ps1 Computer01


.EXAMPLE
#.\Get-Uptime.ps1 Computer01 -AsAString
.PARAMETER ComputerName
Name of the computer to check
.PARAMETER String
Format output as a string
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $ComputerName,

    [Parameter()]
    [switch]
    $AsAString
)

try {
    $Parameters = @{
        Computer    = $ComputerName
        Class       = "Win32_OperatingSystem"
        ErrorAction = "Stop"
    }
    Write-Verbose "Tring to get connect to WMI provider"
    $WMI = Get-WmiObject @Parameters
    $DateSubstr = $WMI.LastBootUpTime.Substring(0, 14)
    $Format = "yyyyMMddHHmmss"
    # There was a fine way with `$wmi.ConvertToDateTime($wmi.LastBootUpTime)` but
    # Method "ConvertToDateTime" not available in PowerShell Core v7
    $Uptime = (Get-Date) - ([datetime]::ParseExact($DateSubstr, $Format, $null))
    if ($AsAString) {
        $Result = "$ComputerName uptime is " `
            + "$($Uptime.Days)d " `
            + "$($Uptime.Hours):" `
            + "$($Uptime.Minutes):" `
            + "$($Uptime.Seconds)"

        return $Result
    } else {
        return $Uptime
    }
}
catch {
    return "Unable to check uptime for $ComputerName"
}