function Select-BsnNetwork {
<#
.SYNOPSIS
    Selects the active BSN.cloud network for subsequent API calls.

.DESCRIPTION
    Sends a PUT request to set the active network on the BSN.cloud session. This must be
    called after Connect-BsnCloud. The module automatically re-selects the network whenever
    it refreshes an expired access token.

.PARAMETER NetworkName
    The name of the network to select.

.PARAMETER NetworkId
    The numeric ID of the network to select.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.OUTPUTS
    [pscustomobject] The updated BsnConnection object.

.EXAMPLE
    Select-BsnNetwork -NetworkName 'Production'

.EXAMPLE
    Select-BsnNetwork -NetworkId 42 -Connection $myConn
#>
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [string] $NetworkName,

        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [int] $NetworkId,

        [psobject] $Connection = $script:BsnSession
    )
    if (-not $Connection) { throw 'Not connected. Provide -Connection or run Connect-BsnCloud first.' }

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        $Connection.Network     = $NetworkId
        $Connection.NetworkIsId = $true
    }
    else {
        $Connection.Network     = $NetworkName
        $Connection.NetworkIsId = $false
    }
    Invoke-BsnNetworkSelect -s $Connection
    return $Connection
}
