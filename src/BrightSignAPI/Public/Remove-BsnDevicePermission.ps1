function Remove-BsnDevicePermission {
<#
.SYNOPSIS
    Removes permissions from a specific device.

.DESCRIPTION
    Removes permissions from a specific device. This cmdlet interacts directly with the BSN.cloud REST API.

.PARAMETER DeviceId
    The numeric BSN.cloud ID of the device.

.PARAMETER Body
    A hashtable indicating the permission to remove.

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)][int]$DeviceId, 
        [Parameter(Mandatory=$true)][object]$Body,
        [psobject]$Connection = $script:BsnSession
    )

    if ($PSCmdlet.ShouldProcess("Device ID $DeviceId", "Remove Permission")) {
        Invoke-BsnApiRequest -Endpoint "/devices/$DeviceId/permissions/" -Method Delete -Body $Body -Connection $Connection | Out-Null
    }
}
