function New-BsnSetupPackage {
<#
.SYNOPSIS
    Creates a new B-Deploy setup package.

.DESCRIPTION
    POSTs a new setup package to B-Deploy (provision.bsn.cloud). The setup package
    defines how players are configured during cloud provisioning, including timezones,
    firmware updates, logging, and internal CA certificates (for 802.1x networks).

.PARAMETER PackageName
    The unique name for this setup package within your BSN.cloud network (required).

.PARAMETER TimeZone
    The timezone the player should operate in (e.g. "America/New_York").

.PARAMETER InternalCaArtifacts
    An array of CA certificate objects (hashtables) with a 'name' and 'asset'.
    Example: @( @{ name = "MyRootCA"; asset = "-----BEGIN CERTIFICATE-----..." } )

.PARAMETER ClientCertificateArtifacts
    An array of client certificate objects (.p12) with a 'name', 'asset' (base64 string),
    and optionally a 'passphrase'.

.PARAMETER Body
    A hashtable containing the full raw Setup Package JSON structure. Useful for advanced
    configurations not covered by explicit parameters.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.OUTPUTS
    [pscustomobject] The created setup package entity.

.EXAMPLE
    $p12Bytes = [System.IO.File]::ReadAllBytes("C:\certs\client.p12")
    $clientCerts = @(
        @{ 
            name = "MyClientCert"
            asset = [Convert]::ToBase64String($p12Bytes)
            passphrase = "mySecretPassword"
        }
    )
    New-BsnSetupPackage -PackageName "VLAN-Setup-1" -ClientCertificateArtifacts $clientCerts
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Basic')]
        [string] $PackageName,

        [Parameter(ParameterSetName = 'Basic')]
        [string] $TimeZone,

        [Parameter(ParameterSetName = 'Basic')]
        [object[]] $InternalCaArtifacts,

        [Parameter(ParameterSetName = 'Basic')]
        [object[]] $ClientCertificateArtifacts,

        [Parameter(Mandatory = $true, ParameterSetName = 'Raw')]
        [hashtable] $Body,

        [Parameter()]
        [psobject] $Connection = $script:BsnSession
    )

    $payload = @{}

    if ($PSCmdlet.ParameterSetName -eq 'Basic') {
        # Construct the Ownership Info Entity (v3)
        $payload.bDeploy = @{
            username    = $Connection.ClientId
            NetworkName = $Connection.Network
            packageName = $PackageName
        }

        # Add explicitly requested properties
        if ($TimeZone) {
            $payload.timeZone = $TimeZone
        }

        if ($InternalCaArtifacts) {
            $payload.internalCaArtifacts = $InternalCaArtifacts
        }

        if ($ClientCertificateArtifacts) {
            $payload.clientCertificateArtifacts = $ClientCertificateArtifacts
        }
    }
    else {
        $payload = $Body
        
        # Ensure bDeploy ownership exists in raw payload
        if (-not $payload.bDeploy) {
            $payload.bDeploy = @{
                username    = $Connection.ClientId
                NetworkName = $Connection.Network
            }
        }
        else {
            if (-not $payload.bDeploy.username)    { $payload.bDeploy.username = $Connection.ClientId }
            if (-not $payload.bDeploy.NetworkName) { $payload.bDeploy.NetworkName = $Connection.Network }
        }
    }

    $resp = Invoke-BsnApiRequest -ApiType ProvisionSetup -Endpoint "/" -Method Post -Body $payload -Connection $Connection
    return $resp
}
