function Remove-BsnProvisioningToken {
<#
.SYNOPSIS
    Revokes (deletes) a BSN.cloud provisioning token.

.DESCRIPTION
    Sends a DELETE request to the BSN.cloud Provisioning API to revoke a previously
    created setup token. The token will no longer be usable for player registration.

.PARAMETER Token
    The provisioning token string to revoke.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.EXAMPLE
    Remove-BsnProvisioningToken -Token 'abc123def456'
#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)][string] $Token,
        [psobject] $Connection = $script:BsnSession
    )

    if ($PSCmdlet.ShouldProcess($Token, 'Revoke provisioning token')) {
        Invoke-BsnApiRequest -Endpoint "/provisioning/setups/tokens/$([uri]::EscapeDataString($Token))/" -Method Delete -Connection $Connection | Out-Null
        Write-Verbose 'Token revoked successfully.'
    }
}
