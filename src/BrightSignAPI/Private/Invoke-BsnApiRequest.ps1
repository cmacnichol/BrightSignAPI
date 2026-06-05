function Invoke-BsnApiRequest {
<#
.SYNOPSIS
    Centralized helper for executing BSN.cloud REST API calls.

.DESCRIPTION
    Wraps Invoke-RestMethod with standard headers, authentication, network validation,
    and structured error handling for the BrightSign module.

.PARAMETER Endpoint
    The API endpoint to append to the base URL (e.g. "/devices/12345/").

.PARAMETER Method
    The HTTP method (Get, Post, Put, Delete). Defaults to Get.

.PARAMETER Body
    The payload to send. If a hashtable or PSObject is provided, it will automatically
    be converted to JSON.

.PARAMETER ApiType
    The type of BSN API to call. Allowed values: 'Core' (default), 'ProvisionDevice', 'ProvisionSetup'.

.PARAMETER Connection
    The BsnConnection object. Defaults to the global session.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Endpoint,

        [Parameter()]
        [string] $Method = 'Get',

        [Parameter()]
        [object] $Body,

        [Parameter()]
        [ValidateSet('Core', 'ProvisionDevice', 'ProvisionSetup')]
        [string] $ApiType = 'Core',

        [Parameter()]
        [psobject] $Connection = $script:BsnSession
    )

    if (-not $Connection) { throw "Not connected. Run Connect-BsnCloud first." }
    
    # Almost all API calls require a network to be selected.
    Assert-BsnNetworkSelected -Connection $Connection

    # Determine the base URL based on ApiType
    $apiBase = switch ($ApiType) {
        'Core' { if ($Connection.ApiBase) { $Connection.ApiBase } else { $script:BsnConfig.ApiBase } }
        'ProvisionDevice' { $script:BsnConfig.ProvisionDeviceUrl }
        'ProvisionSetup' { $script:BsnConfig.ProvisionSetupUrl }
    }
    
    $apiBase = $apiBase.TrimEnd('/')
    $endpointClean = $Endpoint.TrimStart('/')
    $url = "$apiBase/$endpointClean"

    $headers = Get-BsnAuthHeader -Connection $Connection
    $headers['Accept'] = 'application/json'

    $req = [System.Net.HttpWebRequest]::Create($url)
    $req.Method = $Method
    $req.AllowAutoRedirect = $false

    foreach ($key in $headers.Keys) {
        if ($key -eq 'Accept') { $req.Accept = $headers[$key] }
        elseif ($key -eq 'Content-Type') { $req.ContentType = $headers[$key] }
        elseif ($key -eq 'User-Agent') { $req.UserAgent = $headers[$key] }
        else { $req.Headers.Add($key, $headers[$key]) }
    }

    if ($null -ne $Body) {
        if (-not $req.ContentType) { $req.ContentType = 'application/json' }
        $bodyStr = if ($Body -is [string]) { $Body } else { $Body | ConvertTo-Json -Depth 10 -Compress }
        Write-Debug "[Invoke-BsnApiRequest] Body: $bodyStr"
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyStr)
        $req.ContentLength = $bytes.Length
        $reqStream = $req.GetRequestStream()
        $reqStream.Write($bytes, 0, $bytes.Length)
        $reqStream.Close()
    } else {
        if ($Method -eq 'Post' -or $Method -eq 'Put') {
            $req.ContentLength = 0
        }
    }

    try {
        $resp = $req.GetResponse()
        $reader = [System.IO.StreamReader]::new($resp.GetResponseStream())
        $respBody = $reader.ReadToEnd()
        $reader.Close()
        Write-Debug "[Invoke-BsnApiRequest] Success."
        if ($resp.ContentType -match 'json') {
            if ([string]::IsNullOrWhiteSpace($respBody)) { return $null }
            return ($respBody | ConvertFrom-Json)
        }
        return $respBody
    }
    catch {
        Write-Debug "[Invoke-BsnApiRequest] FAILED. Exception: $($_.Exception.Message)"
        throw "$(Get-BsnErrorMessage $_)"
    }
}
