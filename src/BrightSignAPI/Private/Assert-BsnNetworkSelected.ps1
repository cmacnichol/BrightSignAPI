function Assert-BsnNetworkSelected {
<#
.SYNOPSIS
    Validates that a network is currently selected in the BSN.cloud session.

.DESCRIPTION
    Many BSN.cloud REST API endpoints (like /devices) return 403 Forbidden if a
    network session has not been explicitly established. This helper throws a 
    clear, actionable error rather than failing with an obscure HTTP code.
#>
    param(
        [Parameter(Mandatory)]
        [psobject] $Connection
    )

    if (-not $Connection.Network) {
        throw "No BSN.cloud network is currently selected. Please run 'Select-BsnNetwork' to choose a network before running this command."
    }
}
