function Remove-BsnProvisionRecord {
<#
.SYNOPSIS
    Removes a B-Deploy provision record for a player.

.DESCRIPTION
    Sends a DELETE request to B-Deploy (provision.bsn.cloud) to delete one or more
    provision records.

.PARAMETER Id
    Unique identifier of the provision record to delete.

.PARAMETER Serial
    Serial number of the player whose provision record should be deleted.

.PARAMETER IdList
    An array of unique identifiers to delete in bulk.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.EXAMPLE
    Remove-BsnProvisionRecord -Id "1a2b3c..."

.EXAMPLE
    Remove-BsnProvisionRecord -Serial "ABCD00000001"

.EXAMPLE
    Remove-BsnProvisionRecord -IdList @("1a2b3c...", "9z8y7x...")
#>
    [CmdletBinding(DefaultParameterSetName = 'ById', SupportsShouldProcess = $true)]
    param(
        [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
        [string] $Id,

        [Parameter(ParameterSetName = 'BySerial', Mandatory = $true)]
        [string] $Serial,

        [Parameter(ParameterSetName = 'Bulk', Mandatory = $true)]
        [string[]] $IdList,

        [Parameter()]
        [psobject] $Connection = $script:BsnSession
    )

    $endpoint = ""
    $targetName = ""

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        $endpoint = "/?id=$([uri]::EscapeDataString($Id))"
        $targetName = "Record ID $Id"
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'BySerial') {
        $endpoint = "/?serial=$([uri]::EscapeDataString($Serial))"
        $targetName = "Record for Serial $Serial"
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'Bulk') {
        # B-Deploy accepts an array encoded as a JSON string in the URL for bulk deletes
        $jsonArray = $IdList | ConvertTo-Json -Compress
        $endpoint = "/ids/$([uri]::EscapeDataString($jsonArray))"
        $targetName = "$($IdList.Count) records"
    }

    if ($PSCmdlet.ShouldProcess($targetName, "Remove B-Deploy Provision Record")) {
        $resp = Invoke-BsnApiRequest -ApiType ProvisionDevice -Endpoint $endpoint -Method Delete -Connection $Connection
        if ($PSCmdlet.ParameterSetName -eq 'Bulk') {
            Write-Verbose "Bulk delete complete: $($resp.result.message)"
            return $resp.result
        } else {
            Write-Verbose "$targetName deleted successfully."
        }
    }
}
