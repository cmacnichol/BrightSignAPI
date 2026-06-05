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

    $invokeParams = @{
        Method      = $Method
        Uri         = $url
        Headers     = $headers
        ErrorAction = 'Stop'
    }

    if ($null -ne $Body) {
        $invokeParams.ContentType = 'application/json'
        if ($Body -is [string]) {
            $invokeParams.Body = $Body
        } else {
            $invokeParams.Body = ($Body | ConvertTo-Json -Depth 10 -Compress)
        }
    }

    Write-Debug "[Invoke-BsnApiRequest] Calling $Method $url"
    if ($invokeParams.Body) {
        Write-Debug "[Invoke-BsnApiRequest] Body: $($invokeParams.Body)"
    }

    try {
        $response = Invoke-RestMethod @invokeParams
        Write-Debug "[Invoke-BsnApiRequest] Success."
        return $response
    }
    catch {
        Write-Debug "[Invoke-BsnApiRequest] FAILED. Exception: $($_.Exception.Message)"
        throw "$(Get-BsnErrorMessage $_)"
    }
}
