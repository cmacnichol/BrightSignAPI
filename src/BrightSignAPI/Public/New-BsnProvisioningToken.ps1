function New-BsnProvisioningToken {
<#
.SYNOPSIS
    Creates a new BSN.cloud provisioning (registration) token.

.DESCRIPTION
    POSTs to the BSN.cloud Provisioning API to create a setup token. This token is used
    to register a new player with BSN.cloud on first boot.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.OUTPUTS
    [pscustomobject] An object containing the provisioning token and validity details.

.EXAMPLE
    $tokenInfo = New-BsnProvisioningToken
    Write-Host "New token is: $($tokenInfo.token)"
#>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [psobject] $Connection = $script:BsnSession
    )

    Write-Verbose "Creating provisioning token..."
    $resp = Invoke-BsnApiRequest -Endpoint "/provisioning/setups/tokens/" -Method Post -Connection $Connection
    Write-Verbose "Provisioning token created successfully. Valid until: $($resp.validto)"
    return $resp
}
