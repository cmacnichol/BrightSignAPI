function Get-BsnProvisionRecord {
<#
.SYNOPSIS
    Retrieves B-Deploy provision records for players.

.DESCRIPTION
    Gets provision records from the B-Deploy API (provision.bsn.cloud). A provision record
    links a physical player (by serial number) to a Setup Package, allowing automated
    provisioning when the player boots.

.PARAMETER Id
    Unique identifier of the provision record to retrieve.

.PARAMETER Serial
    Serial number of the player to retrieve the provision record for.

.PARAMETER PageNum
    Page index to retrieve (default 0 or 1 depending on API).

.PARAMETER PageSize
    Maximum number of provision records on a page.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.EXAMPLE
    Get-BsnProvisionRecord -Serial "X1E234567890"

.EXAMPLE
    Get-BsnProvisionRecord -PageNum 1 -PageSize 20
#>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
        [string] $Id,

        [Parameter(ParameterSetName = 'BySerial', Mandatory = $true)]
        [string] $Serial,

        [Parameter(ParameterSetName = 'List')]
        [int] $PageNum = 1,

        [Parameter(ParameterSetName = 'List')]
        [int] $PageSize = 20,

        [Parameter()]
        [psobject] $Connection = $script:BsnSession
    )

    $endpoint = "/"
    $queryArgs = @()

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        $queryArgs += "id=$([uri]::EscapeDataString($Id))"
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'BySerial') {
        $queryArgs += "serial=$([uri]::EscapeDataString($Serial))"
    }
    else {
        # List mode requires NetworkName
        $networkName = $Connection.Network
        # If the user used an ID to select the network, we blindly pass it, though it might fail if B-Deploy strictly needs the name.
        $queryArgs += "query[NetworkName]=$([uri]::EscapeDataString($networkName))"
        $queryArgs += "page[pageNum]=$PageNum"
        $queryArgs += "page[pageSize]=$PageSize"
    }

    if ($queryArgs.Count -gt 0) {
        $endpoint += "?" + ($queryArgs -join "&")
    }

    $resp = Invoke-BsnApiRequest -ApiType ProvisionDevice -Endpoint $endpoint -Connection $Connection
    
    # Depending on the endpoint, B-Deploy might return an array, a single object, or a paged result object.
    # We unwrap it for convenience if it looks like the standard { error, result: { players: [...] } } format.
    if ($null -ne $resp.result -and $null -ne $resp.result.players) {
        return $resp.result.players
    }
    
    return $resp
}
