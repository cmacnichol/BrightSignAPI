function Get-BsnSetupPackage {
<#
.SYNOPSIS
    Retrieves B-Deploy setup packages.

.DESCRIPTION
    Gets setup packages from the B-Deploy Setup API (provision.bsn.cloud/rest-setup/v3/setup/).
    A Setup Package dictates firmware versions, timezones, logging rules, and certificate
    installation for devices provisioned through B-Deploy.

.PARAMETER Id
    Unique identifier of the setup package to retrieve.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.EXAMPLE
    Get-BsnSetupPackage

.EXAMPLE
    Get-BsnSetupPackage -Id "f2e1d0c9..."
#>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $false)]
        [string] $Id,

        [Parameter()]
        [psobject] $Connection = $script:BsnSession
    )

    $endpoint = "/"
    if ($Id) {
        $endpoint = "/$([uri]::EscapeDataString($Id))"
    }

    $resp = Invoke-BsnApiRequest -ApiType ProvisionSetup -Endpoint $endpoint -Connection $Connection
    
    # Unwrap if paged response
    if ($null -ne $resp.result -and $null -ne $resp.result.setups) {
        return $resp.result.setups
    }
    
    return $resp
}
