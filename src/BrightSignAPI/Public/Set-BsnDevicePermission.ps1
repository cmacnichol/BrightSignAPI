function Set-BsnDevicePermission {
<#
.SYNOPSIS
    Assigns a permission to a specific device.

.DESCRIPTION
    Assigns a permission to a specific device. This cmdlet interacts directly with the BSN.cloud REST API.

.PARAMETER DeviceId
    The numeric BSN.cloud ID of the device.

.PARAMETER Body
    A hashtable containing the permission payload.

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][int]$DeviceId, 
        [Parameter(Mandatory=$true)][object]$Body,
        [psobject]$Connection = $script:BsnSession
    )

    return Invoke-BsnApiRequest -Endpoint "/devices/$DeviceId/permissions/" -Method Post -Body $Body -Connection $Connection
}
