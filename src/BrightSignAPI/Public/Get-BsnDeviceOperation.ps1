function Get-BsnDeviceOperation {
<#
.SYNOPSIS
    Fetches the status of bulk operations on devices.

.DESCRIPTION
    Fetches the status of bulk operations on devices. This cmdlet interacts directly with the BSN.cloud REST API.

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding()]
    param([psobject]$Connection = $script:BsnSession)

    return Invoke-BsnApiRequest -Endpoint "/devices/operations/" -Connection $Connection
}
