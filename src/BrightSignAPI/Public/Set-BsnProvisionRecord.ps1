function Set-BsnProvisionRecord {
<#
.SYNOPSIS
    Modifies an existing B-Deploy provision record for a player.

.DESCRIPTION
    Sends a PUT request to B-Deploy (provision.bsn.cloud) to update a provision record.
    The request body includes the same core properties as New-BsnProvisionRecord, plus the
    record ID.

.PARAMETER Id
    Unique 24-character identifier of the provision record to update (required).

.PARAMETER Serial
    The serial number of the player (required).

.PARAMETER SetupName
    The name of the setup package stored in B-Deploy to apply.

.PARAMETER SetupId
    The ID of the setup package stored in B-Deploy. Required if SetupName is used.

.PARAMETER Url
    An external URL from which the player downloads its presentation (mutually exclusive with SetupName/SetupId).

.PARAMETER PlayerName
    Player name assigned during provisioning.

.PARAMETER Description
    Player description assigned during provisioning.

.PARAMETER Model
    The player model (e.g. "XC4055").

.PARAMETER Userdata
    Additional custom setup package attributes.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.EXAMPLE
    Set-BsnProvisionRecord -Id "1a2b3c..." -Serial "ABCD00000001" -Url "https://my.app/autorun.zip"
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Id,

        [Parameter(Mandatory = $true)]
        [string] $Serial,

        [Parameter()]
        [string] $SetupName,

        [Parameter()]
        [string] $SetupId,

        [Parameter()]
        [string] $Url,

        [Parameter()]
        [string] $PlayerName,

        [Parameter()]
        [string] $Description,

        [Parameter()]
        [string] $Model,

        [Parameter()]
        [string] $Userdata,

        [Parameter()]
        [psobject] $Connection = $script:BsnSession
    )

    if ($Url -and ($SetupId -or $SetupName)) {
        throw "You must specify EITHER Url OR (SetupId and SetupName), not both."
    }
    if (($SetupId -and -not $SetupName) -or ($SetupName -and -not $SetupId)) {
        throw "If using a B-Deploy setup package, you must specify BOTH SetupId and SetupName."
    }
    if (-not $Url -and -not $SetupId) {
        throw "You must specify either Url or a SetupId/SetupName."
    }

    $body = @{
        _id         = $Id
        serial      = $Serial
        username    = $Connection.ClientId
        NetworkName = $Connection.Network
    }

    if ($PlayerName)  { $body.name = $PlayerName }
    if ($Description) { $body.desc = $Description }
    if ($Model)       { $body.model = $Model }
    if ($Userdata)    { $body.userdata = $Userdata }
    
    if ($Url) {
        $body.url = $Url
    }
    else {
        $body.setupId = $SetupId
        $body.setupName = $SetupName
    }

    $endpoint = "/?id=$([uri]::EscapeDataString($Id))"
    Invoke-BsnApiRequest -ApiType ProvisionDevice -Endpoint $endpoint -Method Put -Body $body -Connection $Connection | Out-Null
    Write-Verbose "Provision record $Id updated."
}
