# Getting Started with BrightSignAPI

Welcome to the `BrightSignAPI` PowerShell module! This module provides a native, object-oriented way to interact with the BSN.cloud REST API and provision BrightSign players using templates.

## 1. Installation

You can install the module from the PowerShell Gallery (once published), or import it directly from the source directory:

```powershell
# From local source
Import-Module C:\Path\To\BrightSignAPI\src\BrightSignAPI\BrightSignAPI.psd1
```

## 2. Authentication

Before running any commands, you must authenticate to BSN.cloud using your API credentials.

```powershell
Connect-BsnCloud -ClientId "your-client-id" -ClientSecret "your-client-secret"
```

If your account has access to multiple networks, `Connect-BsnCloud` will prompt you to select one. Alternatively, you can specify it directly:

```powershell
Connect-BsnCloud -ClientId "..." -ClientSecret "..." -Network "My Organization Network"
```

The connection token is securely stored in your global PowerShell session, so you don't need to pass it to subsequent cmdlets.

## 3. Provisioning a Player

The primary purpose of this module is to automate the deployment of BrightSign players. Instead of manually using BrightAuthor:connected to generate setup files for every device, you can use `New-BsnPlayer` to clone a "golden" template folder and inject unique properties (Name, Registration Token, MAC Addresses, Certificates) into the `setup.json`.

```powershell
New-BsnPlayer -Name 'Lobby-Display-01' `
              -SourceFolder 'C:\Templates\CorporateLobby' `
              -DestinationRoot 'C:\Deployments\' `
              -MacEthernet 'AABBCCDDEEFF'
```

### Batch Provisioning

You can easily provision dozens of players at once by piping a CSV file directly into `New-BsnPlayer`:

```powershell
Import-Csv .\players.csv | New-BsnPlayer -SourceFolder 'C:\Templates\CorporateLobby' -OutResultFile 'C:\Deployments\Results.csv'
```

The `-OutResultFile` parameter is highly recommended for batch jobs. It automatically appends a rich CSV record of every generated player, including the freshly requested BSN.cloud registration token and its expiration timestamp.

## 4. Managing Devices

You can interact with devices already registered to your BSN.cloud network using standard PowerShell verbs:

```powershell
# List all devices
Get-BsnDevice

# Find a specific device by name
Get-BsnDevice | Where-Object { $_.name -like "*Lobby*" }

# Restart a device
Restart-BsnDevice -DeviceId 12345
```

For more details on specific cmdlets, check out the wiki pages for each command!
