# Architecture Overview

The `BrightSignAPI` module is designed to interact efficiently with the BSN.cloud REST API, with a specific focus on robust connection management, error handling, and offline template-based device provisioning.

## Core Design Principles

1. **Global Connection State:**
   Authentication tokens and network selection are managed centrally via `$script:BsnSession`. This allows users to authenticate once using `Connect-BsnCloud` and run subsequent commands without needing to pipe or pass credential objects everywhere.
   
2. **Native Exception Handling:**
   The BSN.cloud API frequently utilizes standard HTTP status codes (400, 401, 404, 500) to communicate errors. The module core uses a unified `Invoke-BsnApiRequest` engine to standardize API calls. It relies on `[System.Net.HttpWebRequest]` natively rather than standard PowerShell WebCmdlets, entirely bypassing known PowerShell 5.1/7.0 bugs relating to HTTPS-to-HTTP downgrade `Location` headers often returned by the BrightSign Provisioning API endpoints. 
   
   Errors are intercepted and parsed natively by `Get-BsnErrorMessage`, which attempts to extract the JSON error payload from the HTTP response stream to provide a clean, human-readable PowerShell exception.

3. **Template-Driven Provisioning:**
   Instead of generating complex XML or JSON configuration payloads from scratch, the module favors a "Golden Template" cloning approach via `New-BsnPlayer`. You define an ideal configuration natively in BrightAuthor:connected, export the setup folder once, and the module surgically rewrites the precise attributes needed (Name, Registration Tokens, MAC mappings, Certificates) inside the `setup.json` payload, ensuring maximum compatibility with future BrightSign OS features without requiring constant module updates.

## Component Layout

### Public Cmdlets
Found in `src/BrightSignAPI/Public/`, these are the user-facing commands exported by the module.
- **Connection Management:** `Connect-BsnCloud`, `Disconnect-BsnCloud`, `Test-BsnConnection`, `Get-BsnNetwork`, `Select-BsnNetwork`.
- **Device Provisioning:** `New-BsnPlayer`, `New-BsnProvisioningToken`, `Get-BsnProvisionRecord`, `New-BsnSetupPackage`.
- **Device Management:** `Get-BsnDevice`, `Set-BsnDevice`, `Remove-BsnDevice`, `Restart-BsnDevice`.

### Private Functions
Found in `src/BrightSignAPI/Private/`, these are internal helper functions not exposed directly to the user.
- **`Invoke-BsnApiRequest`**: The heavy-lifting `.NET` WebRequest wrapper that safely handles headers, payloads, JSON serialization, and bypasses redirection bugs.
- **`Get-BsnErrorMessage`**: Unwraps `System.Net.WebException` streams to extract BrightSign-specific JSON error messages.
- **`Get-BsnAuthHeader`**: Dynamically generates the required Bearer headers for API endpoints based on the current `$script:BsnSession`.

## B-Deploy / Provisioning Flow

The provisioning architecture utilizes BSN.cloud's B-Deploy system. When `New-BsnPlayer` is executed:
1. It requests a one-time Registration Token from the OAuth2 `client_credentials` protected `/provisioning/setups/tokens` endpoint.
2. The token, along with device-specific names and network priorities, are injected directly into the `meta.server` and `meta.client` JSON objects inside `setup.json`.
3. If certificates are provided, they are physically copied into the player directory, and the Wi-Fi/Wired WPA configurations inside `setup.json` are dynamically repointed to them.
4. The resulting folder is ready to be written to an SD card for true plug-and-play BrightSign deployment.
