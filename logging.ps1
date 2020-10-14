#-------------------------------------------------------------------------------
function Write-Log {
    param (
        [Parameter(Mandatory = $true)][String]$Severity,
        # Severity values:
        #   Info - All is OK
        #   Warning - Appeared another state, but may be it's normal beavior
        #   Error - Something goes wrong, but we'll go further
        #   Critical - Something goes wrong and the script will exit
        [String]$Location = $env:computername,
        [Parameter(Mandatory = $true)][String]$Message,
        [String]$LogFile = "log.csv"
    )
    # Set CSV header
    $Header = "Timestamp,Severity,Location,Message"

    # Check variables
    if (($Severity.Length -eq 0) `
            -or ($Location.Length -eq 0) `
            -or ($Message.Length -eq 0)) {
        return
    }

    # Add header string if logfile is not present
    if (Test-Path -Path $LogFile) {
        if ((Get-Content $LogFile).Length -le 1) {
            Remove-Item -Path $LogFile
            try {
                $Header | Out-File -FilePath $LogFile
            }
            catch {
                Write-Warning "Unable to write to $LogFile"
            }
        }
    }
    else {
        try {
            $Header | Out-File -FilePath $LogFile
        }
        catch {
            Write-Warning "Unable to write to $LogFile"
        }
    }

    # Write new string to logfile
    try {
        if ($script:Verbose) {
            if ($Severity.ToLower() -eq "info") {
                Write-Host ($Location + ' : ' + $Message)
            }
            else {
                Write-Warning ($Location + ' : ' + $Message)
            }
        }
        else {
            if (($Severity.ToLower() -eq "error") `
                    -or ($Severity.ToLower() -eq "critical")) {
                Write-Warning ($Location + ' : ' + $Message)
            }
        }

        $(Get-Date -Format G) + ',' `
            + $Severity + ',' `
            + $Location + ',' `
            + $Message | Out-File -FilePath $LogFile -Append
    }
    catch {
        Write-Warning "Unable to write to $LogFile"
    }

    if ($Severity.ToLower() -eq "critical") { exit }
}