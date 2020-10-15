function Import-JSONtoRegistry ($JSON, $RegistryPath) {
    foreach ($Key in $JSON.Keys) {
        try {
            if (-not (Test-Path "$RegistryPath\$Key")) {
                New-Item -Path "$RegistryPath\$Key" `
                    -Type Directory `
                    -Force `
                    -ErrorAction Stop | Out-Null
            }
        }
        catch {
            return $false
        }

        foreach ($SubKey in $JSON[$Key].Keys) {
            try {
                $RegItem = Get-Item $RegistryPath
                $RegKey = $RegItem.OpenSubKey("$Key",$true)
                $RegKey.CreateSubKey($SubKey)
            }
            catch {
                return $false
            }
            foreach ($Parameter in $JSON[$Key][$SubKey].Keys) {
                $Type = $JSON[$Key][$SubKey][$Parameter]["Type"]
                $Value = $JSON[$Key][$SubKey][$Parameter]["Value"]
                try {
                    New-ItemProperty -Path "$RegistryPath\$Key\$SubKey"  `
                        -Name $Parameter `
                        -PropertyType $Type `
                        -Value $Value `
                        -Force `
                        -ErrorAction Stop | Out-Null
                }
                catch {
                    return $false
                }
            }
        }
    }
}
