function Disconnect-BsnCloud {
<#
.SYNOPSIS
    Clears the cached BSN.cloud session and credentials from memory.

.DESCRIPTION
    Removes the module-scoped session object that holds the access token and cached
    client credentials. Call this when you are done working with BSN.cloud to ensure
    sensitive material is not retained in memory longer than necessary.

.EXAMPLE
    Disconnect-BsnCloud
#>
    [CmdletBinding()]
    param()

    $script:BsnSession = $null
    Write-Verbose 'BSN.cloud session cleared.'
}
