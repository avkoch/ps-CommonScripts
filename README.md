# PowerShell common scripts

## Elevate.ps1

Is used to elevate script execution. If it was started with restricted permission this code will invoke PowerShell process with elevated privileges and run script again. Originated by [Ben Armstrong](https://docs.microsoft.com/ru-ru/archive/blogs/virtual_pc_guy/a-self-elevating-powershell-script)

## Import-JSONtoRegistry.ps1

To import JSONed structure to registry. The sample JSON below:

```powershell
$JSON = @{
    "Key" = @{
        "Subkey" = @{
            "Parameter" = @{
                "Type"  = "DWORD";
                "Value" = 0;
            };
        };
    };
}
```

creates structure

```
[Key]
    [Subkey]
        - Parameter = Value
```

Nice solution, but puts hard restrictions on the data we import if we have more or less key tree.

## logging.ps1

Have function aimed to create csv logfile with headers "Timestamp", "Severity", "Location" and "Message".

Severity can be:

* Info
* Warning
* Error
* Critical

## Get-Uptime.ps1

Get uptime of the remote computer as **TimeSpan** or **String**