function Remove-BsnDevice {
<#
.SYNOPSIS
    Removes a device or multiple devices from the BSN.cloud network.

.DESCRIPTION
    Sends a DELETE request to the BSN.cloud Devices API to remove one or more players.

.PARAMETER Id
    The numeric BSN.cloud ID of a single device to remove.

.PARAMETER Ids
    An array of numeric BSN.cloud IDs of devices to remove in bulk.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.EXAMPLE
    Remove-BsnDevice -Id 12345
#>
    [CmdletBinding(DefaultParameterSetName='Single', SupportsShouldProcess=$true, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory=$true, ParameterSetName='Single')]
        [int]$Id,

        [Parameter(Mandatory=$true, ParameterSetName='Bulk')]
        [int[]]$Ids,

        [psobject] $Connection = $script:BsnSession
    )

    if ($PSCmdlet.ShouldProcess("Device ID(s) $(if($Id){$Id}else{$Ids -join ', '})", "Delete Device from BSN.cloud")) {
        if ($PSCmdlet.ParameterSetName -eq 'Single') {
            Invoke-BsnApiRequest -Endpoint "/devices/$Id" -Method Delete -Connection $Connection | Out-Null
        } else {
            Invoke-BsnApiRequest -Endpoint "/devices" -Method Delete -Body $Ids -Connection $Connection | Out-Null
        }
    }
}
