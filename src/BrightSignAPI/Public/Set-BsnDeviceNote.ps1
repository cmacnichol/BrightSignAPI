function Set-BsnDeviceNote {
<#
.SYNOPSIS
    Updates the administrative notes for a specific device.

.PARAMETER DeviceId
    The numeric BSN.cloud ID of the device.

.PARAMETER Body
    A hashtable containing the note (e.g. @{ note = "Cable replaced" }).

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][int]$DeviceId, 
        [Parameter(Mandatory=$true)][object]$Body,
        [psobject]$Connection = $script:BsnSession
    )

    return Invoke-BsnApiRequest -Endpoint "/devices/$DeviceId/notes/" -Method Put -Body $Body -Connection $Connection
}
