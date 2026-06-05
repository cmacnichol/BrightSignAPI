function Get-BsnAuthHeader {
    param([psobject] $Connection = $script:BsnSession)
    if (-not $Connection) { throw 'Not connected. Provide -Connection or run Connect-BsnCloud first.' }
    if ((Get-Date) -ge $Connection.ExpiresAt) {
        Write-Verbose 'Access token expired; re-authenticating.'
        Invoke-BsnTokenRequest -s $Connection
        Invoke-BsnNetworkSelect -s $Connection   # re-select network for the fresh token
    }
    return @{ Authorization = "Bearer $($Connection.AccessToken)" }
}
