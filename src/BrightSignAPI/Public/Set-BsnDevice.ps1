function Set-BsnDevice {
<#
.SYNOPSIS
    Updates a device registered in the BSN.cloud network.

.DESCRIPTION
    Sends a PUT request to the BSN.cloud Devices API to update properties of a specific player.
    Supports partial updates by accepting a hashtable or PSObject for the Body.

.PARAMETER Id
    The numeric BSN.cloud ID of the device to update.

.PARAMETER Body
    A hashtable or object representing the fields to update (e.g. @{ name = "NewName" }).

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.OUTPUTS
    [pscustomobject] The updated device object returned by the API.

.EXAMPLE
    Set-BsnDevice -Id 12345 -Body @{ name = 'LobbyPlayer'; description = 'Main entrance' }
#>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory=$true)]
        [int]$Id,

        [Parameter(Mandatory=$true)]
        [object]$Body,

        [psobject] $Connection = $script:BsnSession
    )

    return Invoke-BsnApiRequest -Endpoint "/devices/$Id" -Method Put -Body $Body -Connection $Connection
}
