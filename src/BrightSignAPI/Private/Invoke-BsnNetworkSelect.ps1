function Invoke-BsnNetworkSelect {
    param($s)
    if (-not $s.Network) { return }
    $body = if ($s.NetworkIsId) { @{ id = [int]$s.Network } } else { @{ name = "$($s.Network)" } }
    $bodyJson = $body | ConvertTo-Json
    $url = "$($s.ApiBase)/self/session/network"
    $headers = @{ 
        Authorization = "Bearer $($s.AccessToken)" 
        Accept = 'application/json'
    }

    Write-Debug "[Invoke-BsnNetworkSelect] Calling PUT $url"
    Write-Debug "[Invoke-BsnNetworkSelect] Headers: $($headers | Out-String)"
    Write-Debug "[Invoke-BsnNetworkSelect] Body: $($bodyJson)"

    try {
        Invoke-RestMethod -Method Put -Uri $url -Headers $headers -Body $bodyJson -ContentType 'application/json' -ErrorAction Stop | Out-Null
        Write-Debug "[Invoke-BsnNetworkSelect] Success."
    }
    catch {
        Write-Debug "[Invoke-BsnNetworkSelect] FAILED. Exception: $($_.Exception.Message)"
        throw "Network selection failed for '$($s.Network)': $(Get-BsnErrorMessage $_)"
    }
    Write-Verbose "Selected network '$($s.Network)'."
}
