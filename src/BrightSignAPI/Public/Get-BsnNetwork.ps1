function Get-BsnNetwork {
<#
.SYNOPSIS
    Lists the BSN.cloud networks available to the authenticated user.

.DESCRIPTION
    Queries the BSN.cloud REST API for available networks. Falls back to the
    /self/session/networks endpoint if the primary endpoint is unavailable.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.OUTPUTS
    [pscustomobject] Network objects returned by the BSN.cloud API.

.EXAMPLE
    Get-BsnNetwork
#>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [psobject] $Connection = $script:BsnSession
    )
    
    $headers = Get-BsnAuthHeader -Connection $Connection
    $headers['Accept'] = 'application/json'
    
    $apiBase = if ($Connection.ApiBase) { $Connection.ApiBase } else { $script:BsnConfig.ApiBase }

    $url = "$apiBase/self/networks"
    
    Write-Debug "[Get-BsnNetwork] Calling GET $url"
    Write-Debug "[Get-BsnNetwork] Headers: $($headers | Out-String)"

    try {
        $resp = Invoke-RestMethod -Method Get -Uri $url -Headers $headers -ErrorAction Stop
        Write-Debug "[Get-BsnNetwork] Success. Received $($resp.Count) networks."
        return $resp
    }
    catch {
        Write-Debug "[Get-BsnNetwork] FAILED. Exception: $($_.Exception.Message)"
        throw "Failed to get networks (URL: $url): $(Get-BsnErrorMessage $_)"
    }
}
