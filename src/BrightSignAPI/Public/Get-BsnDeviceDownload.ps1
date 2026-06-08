function Get-BsnDeviceDownload {
<#
.SYNOPSIS
    Fetches the download logs and progress for a specific device.

.DESCRIPTION
    Fetches the download logs and progress for a specific device. This cmdlet interacts directly with the BSN.cloud REST API.

.PARAMETER DeviceId
    The numeric BSN.cloud ID of the device.

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][int]$DeviceId, [psobject]$Connection = $script:BsnSession)

    return Invoke-BsnApiRequest -Endpoint "/devices/$DeviceId/downloads/" -Connection $Connection
}
