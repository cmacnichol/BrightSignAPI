function Remove-BsnDeviceTag {
<#
.SYNOPSIS
    Removes tags from a specific device.

.DESCRIPTION
    Removes tags from a specific device. This cmdlet interacts directly with the BSN.cloud REST API.

.PARAMETER DeviceId
    The numeric BSN.cloud ID of the device.

.PARAMETER Body
    A hashtable/object representing the tags to remove. Usually requires the tag ID or Name in the body based on BrightSign API specs.

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)][int]$DeviceId, 
        [Parameter(Mandatory=$true)][object]$Body,
        [psobject]$Connection = $script:BsnSession
    )

    if ($PSCmdlet.ShouldProcess("Device ID $DeviceId", "Remove Tag")) {
        Invoke-BsnApiRequest -Endpoint "/devices/$DeviceId/tags/" -Method Delete -Body $Body -Connection $Connection | Out-Null
    }
}
