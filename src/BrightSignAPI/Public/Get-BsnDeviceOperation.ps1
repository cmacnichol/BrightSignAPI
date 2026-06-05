function Get-BsnDeviceOperation {
<#
.SYNOPSIS
    Fetches the status of bulk operations on devices.

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding()]
    param([psobject]$Connection = $script:BsnSession)

    return Invoke-BsnApiRequest -Endpoint "/devices/operations/" -Connection $Connection
}
