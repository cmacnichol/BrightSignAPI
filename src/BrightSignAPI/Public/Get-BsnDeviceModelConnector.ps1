function Get-BsnDeviceModelConnector {
<#
.SYNOPSIS
    Fetches the list of connectors (e.g., HDMI, Audio) supported by a specific BrightSign model.

.DESCRIPTION
    Fetches the list of connectors (e.g., HDMI, Audio) supported by a specific BrightSign model. This cmdlet interacts directly with the BSN.cloud REST API.

.PARAMETER Model
    The specific model name (e.g. "XD1034").

.PARAMETER Connection
    A BsnConnection object.
#>
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][string]$Model, [psobject]$Connection = $script:BsnSession)

    return Invoke-BsnApiRequest -Endpoint "/devices/models/$Model/connectors/" -Connection $Connection
}
