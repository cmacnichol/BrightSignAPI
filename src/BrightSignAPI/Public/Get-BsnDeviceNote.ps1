function Get-BsnDeviceNote {
<#
.SYNOPSIS
    Fetches administrative notes for devices.

.PARAMETER DeviceId
    The numeric BSN.cloud ID of the device.

.PARAMETER All
    Switch to fetch notes for all devices instead of a specific one.

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding(DefaultParameterSetName='ById')]
    param(
        [Parameter(ParameterSetName='ById', Mandatory=$true)]
        [int]$DeviceId,

        [Parameter(ParameterSetName='All', Mandatory=$true)]
        [switch]$All,

        [psobject]$Connection = $script:BsnSession
    )

    $endpoint = if ($All) { "/devices/all/notes/" } else { "/devices/$DeviceId/notes/" }
    return Invoke-BsnApiRequest -Endpoint $endpoint -Connection $Connection
}
