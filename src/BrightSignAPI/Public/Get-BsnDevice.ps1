function Get-BsnDevice {
<#
.SYNOPSIS
    Fetches devices registered in the current BSN.cloud network.

.DESCRIPTION
    Queries the BSN.cloud Devices API to retrieve player information. Supports lookup
    by ID (single API call), by name, or by serial number (client-side filtering on
    a full paginated fetch). Also supports standard BSN.cloud server-side filtering
    via the Filter, Sort, Marker, and PageSize parameters.

.PARAMETER Id
    Fetch a single device by its numeric BSN.cloud ID.

.PARAMETER Name
    Filter devices by name (matches settings.name or name).

.PARAMETER Serial
    Filter devices by serial number.

.PARAMETER Filter
    An expression for filtering search results server-side (e.g. "[model] is 'HD1024'").

.PARAMETER Sort
    An expression for sorting the search results (e.g. "[lastModifiedDate] asc").

.PARAMETER Marker
    A value specifying which page to retrieve (nextMarker from previous response).

.PARAMETER PageSize
    The maximum number of device instances that can be contained in the response.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.
#>
    [CmdletBinding(DefaultParameterSetName='All')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(ParameterSetName='ById')]
        [int]$Id,

        [Parameter(ParameterSetName='ByName')]
        [string]$Name,

        [Parameter(ParameterSetName='BySerial')]
        [string]$Serial,

        [Parameter(ParameterSetName='All')]
        [string]$Filter,

        [Parameter(ParameterSetName='All')]
        [string]$Sort,

        [Parameter(ParameterSetName='All')]
        [string]$Marker,

        [Parameter(ParameterSetName='All')]
        [int]$PageSize,

        [psobject] $Connection = $script:BsnSession
    )

    if ($Id) {
        return Invoke-BsnApiRequest -Endpoint "/devices/$Id" -Connection $Connection
    }
    else {
        # Build query parameters
        $queryParams = @()
        if ($Filter)   { $queryParams += "filter=$([uri]::EscapeDataString($Filter))" }
        if ($Sort)     { $queryParams += "sort=$([uri]::EscapeDataString($Sort))" }
        if ($PageSize) { $queryParams += "pageSize=$PageSize" }

        # If a specific Marker/PageSize is provided, we do a single fetch.
        # Otherwise, we paginate to fetch all devices.
        if ($Marker -or $PageSize -or $Filter) {
            if ($Marker) { $queryParams += "marker=$([uri]::EscapeDataString($Marker))" }
            $qs = if ($queryParams) { "?$($queryParams -join '&')" } else { "" }
            return Invoke-BsnApiRequest -Endpoint "/devices$qs" -Connection $Connection
        }
        else {
            $allDevices = [System.Collections.Generic.List[object]]::new()
            $currentMarker = $null
            
            do {
                $loopParams = $queryParams
                if ($currentMarker) { $loopParams += "marker=$([uri]::EscapeDataString($currentMarker))" }
                $qs = if ($loopParams) { "?$($loopParams -join '&')" } else { "" }
                
                $resp = Invoke-BsnApiRequest -Endpoint "/devices$qs" -Connection $Connection
                if ($resp.items) { $allDevices.AddRange([object[]]$resp.items) }
                $currentMarker = $resp.nextMarker
            } while ($currentMarker)

            if ($Name) {
                return $allDevices | Where-Object { $_.settings.name -eq $Name -or $_.name -eq $Name }
            }
            elseif ($Serial) {
                return $allDevices | Where-Object { $_.serial -eq $Serial }
            }
            else {
                return $allDevices
            }
        }
    }
}
