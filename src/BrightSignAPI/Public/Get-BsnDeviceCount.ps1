function Get-BsnDeviceCount {
<#
.SYNOPSIS
    Gets the total number of devices registered in the current BSN.cloud network.

.DESCRIPTION
    Queries the BSN.cloud Devices Count API to retrieve the total number of players.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.OUTPUTS
    [int] The total number of devices.

.EXAMPLE
    Get-BsnDeviceCount
#>
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [psobject] $Connection = $script:BsnSession
    )

    $resp = Invoke-BsnApiRequest -Endpoint "/devices/count/" -Connection $Connection
    
    # If the API returns a raw integer (e.g. 2), PowerShell parses it as an [int] (PS5) or [int64] (PS7).
    # But scalar numbers have a built-in .Count property that always returns 1. 
    # We must check if the response itself is the integer to avoid returning 1.
    if ($resp -is [int] -or $resp -is [int64] -or $resp -is [string]) {
        return [int]$resp
    } elseif ($null -ne $resp.count) {
        return [int]$resp.count
    } else {
        throw "Unexpected response from /devices/count/: $resp"
    }
}
