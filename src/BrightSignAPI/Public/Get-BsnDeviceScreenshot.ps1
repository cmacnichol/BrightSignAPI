function Get-BsnDeviceScreenshot {
<#
.SYNOPSIS
    Fetches screenshots captured from players.

.DESCRIPTION
    Fetches screenshots captured from players. This cmdlet interacts directly with the BSN.cloud REST API.

.PARAMETER DeviceId
    The numeric BSN.cloud ID of the device. Omit to fetch for all devices.

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding(DefaultParameterSetName='All')]
    param(
        [Parameter(ParameterSetName='ById', Mandatory=$true)]
        [int]$DeviceId,
        [psobject]$Connection = $script:BsnSession
    )

    $endpoint = if ($DeviceId) { "/devices/$DeviceId/screenshots/" } else { "/devices/screenshots/" }
    return Invoke-BsnApiRequest -Endpoint $endpoint -Connection $Connection
}
