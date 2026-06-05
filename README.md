# BSN BrightSign Provisioning Tool

> [!WARNING]
> **Work In Progress**: This module is currently under active development. While the core offline provisioning and device restart cmdlets are verified, not all API wrapper functions have been fully tested in a production environment. Use with caution.

A small PowerShell module that makes provisioning new BrightSign players **repeatable and easy**:
it fetches a per-device **registration token** from BSN.cloud (OAuth2 client-credentials) and
clones a known-good player folder, rewriting the values that differ per player in `setup.json`, while automatically swapping physical certificates. It also natively supports the **B-Deploy** (provision.bsn.cloud) APIs for complete remote cloud provisioning!

> Why PowerShell: the target is Windows, the files live on a CIFS share, and the job is
> mostly file manipulation plus one OAuth2/REST call — all native to PowerShell
> (`Invoke-RestMethod`, `Copy-Item`, `ConvertFrom-Json`). No extra runtime to install or hand off.

## One-time setup

1. In the BSN.cloud admin panel (<https://adminpanel.bsn.cloud>), select your network and
   generate **client credentials** (a `client_id` and `client_secret`) for the
   client-credentials flow.
2. Import the module:
   ```powershell
   Import-Module ".\BrightSignAPI.psd1" -Force
   ```

## Provisioning Players (Offline/SD Card)

The module uses a single core cmdlet, `New-BsnPlayer`, which is designed to accept pipeline input. This allows you to easily provision a single player manually or batch-provision hundreds of players from a CSV file.

### 1. Authenticate
Authenticate against the BSN.cloud API to allow the module to generate unique provisioning tokens.
```powershell
# Authenticate (you'll be prompted for the secret so it stays out of history)
$secret = Read-Host "Client secret" -AsSecureString
Connect-BsnCloud -ClientId 'YOUR_CLIENT_ID' -ClientSecret $secret

# Select the network (required after every new token)
Select-BsnNetwork -NetworkName 'BSN'
```

### 2. Single Player Provisioning
```powershell
New-BsnPlayer -Name 'LobbyDisplay01' `
    -SourceFolder '\\server\share\BrightSign\TemplateFolder' `
    -DestinationRoot 'C:\MyNewPlayers' `
    -MacEthernet 'aabbccddeeff' `
    -Description 'Front Desk Lobby Kiosk'
```

### 3. Batch Provisioning from CSV
Because `New-BsnPlayer` accepts pipeline input by property name, you can pipe a CSV directly into it!
Your CSV (e.g., `ImportTemplate.csv`) should contain column headers matching the parameter aliases (e.g., `Name_BSN`, `MAC_Ethernet`, `MAC_WiFi`, `SSID`, `EncryptedCertPass`).

```powershell
Import-Csv .\ImportTemplate.csv | New-BsnPlayer -SourceFolder 'C:\Path\To\Template' -DestinationRoot 'C:\Path\To\Output'
```
*Note: Add `-WhatIf` to any command to dry-run and preview the actions without actually copying files or fetching API tokens.*

## What `New-BsnPlayer` Does

1. **Certificate Pre-Validation**: Before any work begins, `.p12` certificates are loaded locally to verify the passphrase is correct and the file is not corrupt. This prevents unbootable players.
2. **Clones the Folder**: Copies your `SourceFolder` into a new folder named after the player.
3. **Dynamic Tokens**: Reaches out to the BSN API and fetches a unique Registration Token for each player.
4. **Certificate Swapping**: If you provide MAC addresses, it deletes the old `.p12` certificates left over from the template folder. It then looks in your `$CertificatesDirectory` (defaults to `./Certificates/`) for matching `<MAC>.p12` files and securely copies them to the new player folder.
5. **Network Routing**: If both an Ethernet and WiFi MAC address are provided, the script automatically configures the player's routing table so that Ethernet takes priority (`networkConnectionPriorityWired = 0`).
6. **SSID Fallback**: Automatically updates the WiFi SSID. If no SSID is provided, it attempts to use the existing SSID in the template `setup.json`. If the template is empty and a WiFi MAC is supplied, it aborts to prevent a misconfigured player.
7. **JSON Parsing & Overrides**: The `setup.json` is natively parsed and strictly formatted. You can use the `-OverrideConfig` parameter to inject any arbitrary JSON configuration natively!

```powershell
# Using OverrideConfig to inject new arbitrary properties not natively on the cmdlet
$customSettings = @{
    timeZone = "America/Los_Angeles"
    useCustomSplashScreen = $true
}
New-BsnPlayer -Name 'Test' -SourceFolder 'C:\Template' -OverrideConfig $customSettings
```

## B-Deploy (Cloud Provisioning) Cmdlets

If you do not require offline SD cards to inject 802.1x certificates prior to network connection, you can manage cloud provisioning entirely via B-Deploy:

- **Setup Packages**: Create and manage the overarching setup configurations that players download.
  - `Get-BsnSetupPackage`
  - `New-BsnSetupPackage` (Supports `-InternalCaArtifacts` and `-ClientCertificateArtifacts` for PKCS12 certs)
  - `Remove-BsnSetupPackage`
- **Provision Records**: Link a physical player's serial number to a Setup Package or external URL.
  - `Get-BsnProvisionRecord`
  - `New-BsnProvisionRecord`
  - `Set-BsnProvisionRecord`
  - `Remove-BsnProvisionRecord`

## Discovery and Management Cmdlets

You can natively query and manage your BSN.cloud environment using your authenticated session:

- **`Get-BsnNetwork`**: Returns a list of networks your user account has access to.
- **`Get-BsnDevice`**: Fetches players registered in your selected network. 
  - *Example*: `Get-BsnDevice -Name 'LobbyPlayer'` or `Get-BsnDevice -Serial 'aabbccddeeff'`
- **`Restart-BsnDevice`**: Issues a remote reboot command over the cloud to one or more player IDs. Uses a concurrent RunspacePool for high throughput when rebooting many devices.
  - *Example*: `Get-BsnDevice -Name 'LobbyPlayer' | Restart-BsnDevice`
  - *Bulk example*: `Get-BsnDevice | Restart-BsnDevice -ThrottleLimit 20`
- **`Disconnect-BsnCloud`**: Clears the cached session and credentials from memory.

## Multi-Tenant Support

All cmdlets accept a `-Connection` parameter, allowing you to manage multiple BSN.cloud tenants simultaneously:

```powershell
$conn1 = Connect-BsnCloud -ClientId 'tenant1-id' -ClientSecret $secret1
Select-BsnNetwork -NetworkName 'Prod' -Connection $conn1

$conn2 = Connect-BsnCloud -ClientId 'tenant2-id' -ClientSecret $secret2
Select-BsnNetwork -NetworkName 'Staging' -Connection $conn2

# Query devices on each tenant independently
$prodDevices = Get-BsnDevice -Connection $conn1
$stagDevices = Get-BsnDevice -Connection $conn2
```

If you omit `-Connection`, cmdlets default to the most recently created session.

## Enhanced Error Handling

API errors now include the server's JSON error payload in exception messages. Instead of a generic `(401) Unauthorized`, you'll see the actual reason from the BSN.cloud API, making troubleshooting much faster.

## API contract (confirmed against 2022/06 docs)

| Step | Call |
|---|---|
| Authenticate | `POST https://auth.bsn.cloud/realms/bsncloud/protocol/openid-connect/token` — Basic auth header `base64(clientId:clientSecret)`, body `grant_type=client_credentials`, form-encoded. Returns `access_token`, `expires_in`, `scope`. |
| Select network | `PUT https://api.bsn.cloud/2022/06/rest/self/session/network` — Bearer auth, JSON `{"name":"BSN"}` or `{"id":123}`. Returns `204`. |
| Create token | `POST https://api.bsn.cloud/2022/06/rest/provisioning/setups/tokens/` — Bearer auth, **no body**. Returns `{token, scope, validfrom, validto}`. |

> **Short-lived token:** the access token lasts only ~5.5 minutes (no refresh token); the
> network session lasts 24h. The module caches your credentials and **auto-reauthenticates +
> re-selects the network** when the token expires, so batch runs that take longer than 5.5
> minutes keep working without intervention.

Sources:
[Authentication](https://docs.brightsign.biz/developers/authentication)  
[Provisioning Endpoints (2022/06)](https://docs.brightsign.biz/developers/provisioning-endpoints-202206)  
[Devices Endpoints (2022/06)](https://docs.brightsign.biz/developers/devices-endpoints-202206)
