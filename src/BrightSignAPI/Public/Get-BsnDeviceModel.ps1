function Get-BsnDeviceModel {
<#
.SYNOPSIS
    Fetches information about hardware device models supported by BSN.cloud.

.PARAMETER Model
    The specific model name (e.g. "XD1034"). If omitted, lists all models.

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding(DefaultParameterSetName='All')]
    param(
        [Parameter(ParameterSetName='ByName', Mandatory=$true)]
        [string]$Model,
        [psobject]$Connection = $script:BsnSession
    )

    $endpoint = if ($Model) { "/devices/models/$Model/" } else { "/devices/models/" }
    return Invoke-BsnApiRequest -Endpoint $endpoint -Connection $Connection
}
