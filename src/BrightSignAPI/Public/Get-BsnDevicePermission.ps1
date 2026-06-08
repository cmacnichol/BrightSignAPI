function Get-BsnDevicePermission {
<#
.SYNOPSIS
    Fetches the permissions assigned to a specific device.

.DESCRIPTION
    Fetches the permissions assigned to a specific device. This cmdlet interacts directly with the BSN.cloud REST API.

.PARAMETER DeviceId
    The numeric BSN.cloud ID of the device.

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][int]$DeviceId, [psobject]$Connection = $script:BsnSession)

    return Invoke-BsnApiRequest -Endpoint "/devices/$DeviceId/permissions/" -Connection $Connection
}
