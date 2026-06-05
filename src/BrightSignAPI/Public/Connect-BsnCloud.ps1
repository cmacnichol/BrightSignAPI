function Connect-BsnCloud {
<#
.SYNOPSIS
    Authenticates to BSN.cloud using OAuth2 client-credentials and caches the session.

.DESCRIPTION
    Performs a Keycloak client-credentials token request against BSN.cloud. The resulting
    access token and credentials are cached in a module-scoped session object so that
    subsequent cmdlets can automatically re-authenticate when the short-lived token expires.

.PARAMETER ClientId
    Client ID generated in the BSN.cloud admin panel (https://adminpanel.bsn.cloud).

.PARAMETER ClientSecret
    Client secret as a SecureString. Use Read-Host -AsSecureString to avoid plaintext in history.

.PARAMETER TokenUrl
    OAuth2 token endpoint URL. Defaults to the standard BSN.cloud Keycloak endpoint.

.OUTPUTS
    [pscustomobject] A BsnConnection object representing the authenticated session.

.EXAMPLE
    $secret = Read-Host "Client secret" -AsSecureString
    $conn = Connect-BsnCloud -ClientId 'my-client-id' -ClientSecret $secret
#>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $ClientId,

        [Parameter(Mandatory)]
        [securestring] $ClientSecret,

        [string] $TokenUrl = $script:BsnConfig.TokenUrl
    )

    # Cache credentials so the very short-lived (~5.5 min) token can be auto-renewed later.
    $script:BsnSession = [pscustomobject]@{
        PSTypeName   = 'BsnConnection'
        ClientId     = $ClientId
        ClientSecret = $ClientSecret
        TokenUrl     = $TokenUrl
        ApiBase      = $script:BsnConfig.ApiBase
        AccessToken  = $null
        ExpiresAt    = [datetime]::MinValue
        Network      = $null
        NetworkIsId  = $false
    }
    Invoke-BsnTokenRequest -s $script:BsnSession
    Write-Verbose 'Authenticated.'

    # Attempt to auto-select network if only one is available
    try {
        $networks = Get-BsnNetwork -Connection $script:BsnSession -ErrorAction Stop
        if ($networks.Count -eq 1) {
            $net = $networks[0]
            $netName = if ($net.name) { $net.name } else { $net.id }
            Write-Verbose "Only one network found ($netName). Auto-selecting..."
            if ($net.id) {
                Select-BsnNetwork -NetworkId $net.id -Connection $script:BsnSession -ErrorAction Stop
            } else {
                Select-BsnNetwork -NetworkName $net.name -Connection $script:BsnSession -ErrorAction Stop
            }
            Write-Verbose "Network auto-selected successfully."
        } elseif ($networks.Count -gt 1) {
            Write-Warning "Multiple BSN.cloud networks found. You MUST run 'Select-BsnNetwork' to choose one before querying devices or provisioning players."
        } else {
            Write-Warning "No BSN.cloud networks found for this account."
        }
    } catch {
        Write-Warning "Failed to fetch network list for auto-selection: $($_.Exception.Message)"
    }

    return $script:BsnSession
}
