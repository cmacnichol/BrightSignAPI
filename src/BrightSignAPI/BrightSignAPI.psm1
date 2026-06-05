#requires -Version 5.1
<#
    BrightSignAPI.psm1
    ---------------------
    Repeatable provisioning of BrightSign players for BSN.

    This file serves as the module loader, dot-sourcing all public and private 
    functions and initializing module-scoped configuration.
#>

# ---------------------------------------------------------------------------
# Module-level configuration / state
# ---------------------------------------------------------------------------
# Ensure TLS 1.2 is used for older OS defaults
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$script:BsnConfig = @{
    # Base for the 2022/06 BSN.cloud REST API.
    ApiBase              = 'https://api.bsn.cloud/2022/06/rest'

    # Keycloak OAuth2 token endpoint (client-credentials). Basic auth header + form body.
    TokenUrl             = 'https://auth.bsn.cloud/realms/bsncloud/protocol/openid-connect/token'

    # Network selection (PUT, JSON body {"name": ...} or {"id": ...}, returns 204).
    NetworkSelectUrl     = 'https://api.bsn.cloud/2022/06/REST/Self/Session/Network'

    # Provisioning setup-token creation (POST, no body, returns {token, scope, validfrom, validto}).
    ProvisioningTokenUrl = 'https://api.bsn.cloud/2022/06/rest/provisioning/setups/tokens/'

    # B-Deploy Device Provision Records
    ProvisionDeviceUrl   = 'https://provision.bsn.cloud/rest-device/v2/device/'

    # B-Deploy Setup Packages
    ProvisionSetupUrl    = 'https://provision.bsn.cloud/rest-setup/v3/setup/'
}

# Holds the live session (access token, expiry, selected network)
$script:BsnSession = $null

# ---------------------------------------------------------------------------
# Load Functions
# ---------------------------------------------------------------------------
$Public  = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"  -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue)

foreach ($file in @($Public + $Private)) {
    try {
        . $file.FullName
    }
    catch {
        Write-Error "Failed to import function from $($file.FullName): $_"
    }
}
