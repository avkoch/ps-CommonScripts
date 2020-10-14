function Import-JSONtoRegistry ($JSON, $RegistryPath) {
    foreach ($Key in $JSON.Keys) {
        foreach ($SubKey in $JSON[$Key].Keys) {
            foreach ($Parameter in $JSON[$Key][$SubKey].Keys) {
                $Type = $JSON[$Key][$SubKey][$Parameter]["Type"]
                $Value = $JSON[$Key][$SubKey][$Parameter]["Value"]
                try {
                    if (!(Test-Path "$RegistryPath\$Key\$SubKey")) {
                        New-Item -Path "$RegistryPath\$Key\$SubKey" `
                            -Type Directory `
                            -Force `
                            -ErrorAction Stop | Out-Null
                    }
                    New-ItemProperty -Path "$RegistryPath\$Key\$SubKey"  `
                        -Name $Parameter `
                        -PropertyType $Type `
                        -Value $Value `
                        -Force `
                        -ErrorAction Stop | Out-Null

                }
                catch {
                    Write-Warning "Unable to update registry"
                    return
                }
            }
        }
    }
}
