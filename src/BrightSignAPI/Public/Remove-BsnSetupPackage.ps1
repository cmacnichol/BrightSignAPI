function Remove-BsnSetupPackage {
<#
.SYNOPSIS
    Removes a B-Deploy setup package.

.DESCRIPTION
    Sends a DELETE request to B-Deploy (provision.bsn.cloud/rest-setup/v3/setup/) to delete
    an existing setup package.

.PARAMETER Id
    Unique identifier of the setup package to delete (required).

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.EXAMPLE
    Remove-BsnSetupPackage -Id "f2e1d0c9..."
#>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Id,

        [Parameter()]
        [psobject] $Connection = $script:BsnSession
    )

    if ($PSCmdlet.ShouldProcess("Setup Package $Id", "Delete B-Deploy Setup Package")) {
        $endpoint = "/$([uri]::EscapeDataString($Id))"
        $resp = Invoke-BsnApiRequest -ApiType ProvisionSetup -Endpoint $endpoint -Method Delete -Connection $Connection
        Write-Verbose "Setup Package $Id deleted successfully."
        return $resp
    }
}
