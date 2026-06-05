function Add-BsnDeviceTag {
<#
.SYNOPSIS
    Adds a metadata tag to a specific device.

.PARAMETER DeviceId
    The numeric BSN.cloud ID of the device.

.PARAMETER Body
    A hashtable representing the tag (e.g. @{ name = "Location"; value = "HQ" }).

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][int]$DeviceId, 
        [Parameter(Mandatory=$true)][object]$Body,
        [psobject]$Connection = $script:BsnSession
    )

    return Invoke-BsnApiRequest -Endpoint "/devices/$DeviceId/tags/" -Method Post -Body $Body -Connection $Connection
}
