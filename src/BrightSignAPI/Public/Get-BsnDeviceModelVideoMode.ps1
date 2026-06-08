function Get-BsnDeviceModelVideoMode {
<#
.SYNOPSIS
    Fetches the supported video modes for a specific connector on a specific BrightSign model.

.DESCRIPTION
    Fetches the supported video modes for a specific connector on a specific BrightSign model. This cmdlet interacts directly with the BSN.cloud REST API.

.PARAMETER Model
    The specific model name (e.g. "XD1034").

.PARAMETER Connector
    The connector name (e.g. "HDMI").

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Model,
        [Parameter(Mandatory=$true)][string]$Connector,
        [psobject]$Connection = $script:BsnSession
    )

    return Invoke-BsnApiRequest -Endpoint "/devices/models/$Model/connectors/$Connector/videomodes/" -Connection $Connection
}
