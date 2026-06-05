function Invoke-BsnTokenRequest {
    param($s)
    $secretPlain = [System.Net.NetworkCredential]::new('', $s.ClientSecret).Password
    $basic = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("$($s.ClientId):$secretPlain"))
    $secretPlain = $null  # clear reference (the original .NET string is immutable and GC'd separately)

    $url = $s.TokenUrl
    $headers = @{ Authorization = "Basic $basic" }
    $body = @{ grant_type = 'client_credentials' }
    Write-Debug "[Invoke-BsnTokenRequest] Calling POST $url"
    Write-Debug "[Invoke-BsnTokenRequest] Headers: $($headers | Out-String)"
    Write-Debug "[Invoke-BsnTokenRequest] Body: $($body | Out-String)"

    try {
        $resp = Invoke-RestMethod -Method Post -Uri $url `
            -Headers $headers `
            -Body $body `
            -ContentType 'application/x-www-form-urlencoded' -ErrorAction Stop
        Write-Debug "[Invoke-BsnTokenRequest] Success."
    }
    catch {
        Write-Debug "[Invoke-BsnTokenRequest] FAILED. Exception: $($_.Exception.Message)"
        throw "BSN.cloud authentication failed: $(Get-BsnErrorMessage $_)"
    }
    if (-not $resp.access_token) {
        throw "Auth response had no access_token. Raw: $($resp | ConvertTo-Json -Depth 5)"
    }

    # Renew ~30s early to stay clear of the ~5.5 min lifetime.
    $lifetime = [int]($resp.expires_in); if ($lifetime -le 0) { $lifetime = 330 }
    $s.AccessToken = $resp.access_token
    $s.ExpiresAt   = (Get-Date).AddSeconds([Math]::Max(1, $lifetime - 30))
    Write-Verbose "Got access token; valid until $($s.ExpiresAt)."
}
