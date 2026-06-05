function Get-BsnDeviceError {
<#
.SYNOPSIS
    Fetches error logs for a specific device.

.DESCRIPTION
    Queries the BSN.cloud Devices API to retrieve the error history for a player.

.PARAMETER DeviceId
    The numeric BSN.cloud ID of the device.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud.
#>
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][int]$DeviceId, [psobject]$Connection = $script:BsnSession)

    return Invoke-BsnApiRequest -Endpoint "/devices/$DeviceId/errors/" -Connection $Connection
}
