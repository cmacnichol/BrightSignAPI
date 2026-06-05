function Get-BsnProvisioningToken {
<#
.SYNOPSIS
    Retrieves the currently valid BSN.cloud provisioning tokens.

.DESCRIPTION
    Sends a GET request to the BSN.cloud Provisioning API to retrieve setup tokens.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.OUTPUTS
    [pscustomobject] Objects containing the provisioning token(s) and validity details.

.EXAMPLE
    Get-BsnProvisioningToken
#>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [psobject] $Connection = $script:BsnSession
    )

    return Invoke-BsnApiRequest -Endpoint "/provisioning/setups/tokens/" -Connection $Connection
}
