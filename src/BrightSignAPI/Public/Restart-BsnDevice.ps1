function Restart-BsnDevice {
<#
.SYNOPSIS
    Sends a reboot command to one or more BrightSign devices by ID.

.DESCRIPTION
    Issues a remote reboot command to BrightSign players via the BSN.cloud REST API.
    When multiple device IDs are piped in, requests are dispatched concurrently using a
    RunspacePool for high throughput. The token is refreshed mid-batch if it expires.

.PARAMETER Id
    The numeric BSN.cloud device ID to reboot. Accepts pipeline input.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.PARAMETER ThrottleLimit
    Maximum number of concurrent reboot requests. Defaults to 10.

.EXAMPLE
    Restart-BsnDevice -Id 12345

.EXAMPLE
    Get-BsnDevice | Restart-BsnDevice -ThrottleLimit 20

.EXAMPLE
    1001, 1002, 1003 | Restart-BsnDevice
#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]$Id,

        [psobject] $Connection = $script:BsnSession,

        [ValidateRange(1, 100)]
        [int] $ThrottleLimit = 10
    )
    begin {
        # The reboot endpoint uses the rDWS API at ws.bsn.cloud, not the main API.
        $scriptBlock = {
            param($Id, $Serial, $Headers)
            
            if (-not $Serial) {
                return [pscustomobject]@{ Id = $Id; Serial = $null; Success = $false; Error = "Device serial number is required for reboot but could not be resolved." }
            }

            $url = "https://ws.bsn.cloud/rest/v1/control/reboot/?destinationType=player&destinationName=$Serial"
            
            try {
                Invoke-RestMethod -Method Put -Uri $url -Headers $Headers -ErrorAction Stop | Out-Null
                return [pscustomobject]@{ Id = $Id; Serial = $Serial; Success = $true; Error = $null }
            }
            catch {
                # Extract error message inside runspace (Get-BsnErrorMessage is not available here)
                $msg = $_.Exception.Message
                if ($_.Exception -is [System.Net.WebException] -and $_.Exception.Response) {
                    try {
                        $stream = $_.Exception.Response.GetResponseStream()
                        if ($stream.CanSeek) { $stream.Position = 0 }
                        $reader = [System.IO.StreamReader]::new($stream)
                        $json = $reader.ReadToEnd() | ConvertFrom-Json
                        if ($json.message) { $msg += " - $($json.message)" }
                        $reader.Dispose()
                    } catch {}
                }
                return [pscustomobject]@{ Id = $Id; Serial = $Serial; Success = $false; Error = $msg }
            }
        }

        $jobs = [System.Collections.Generic.List[object]]::new()
        $pool = $null  # Deferred creation -- only opened if we actually dispatch work
        $batchCount = 0
    }
    process {
        if ($PSCmdlet.ShouldProcess("Device ID $Id", "Restart (Reboot)")) {
            Assert-BsnNetworkSelected -Connection $Connection

            # Attempt to grab the Serial if the input object has it (e.g. piped from Get-BsnDevice)
            $serialVal = $null
            if ($_ -and $_.serial) {
                $serialVal = $_.serial
            } else {
                # Need to look it up using Get-BsnDevice
                try {
                    $dev = Get-BsnDevice -Id $Id -Connection $Connection -ErrorAction Stop
                    $serialVal = $dev.serial
                } catch {
                    Write-Error "Failed to resolve serial for device ID ${Id}: $($_.Exception.Message)"
                    return
                }
            }

            # Refresh the token if it has expired mid-batch
            $headers = Get-BsnAuthHeader -Connection $Connection
            $headers['Accept'] = 'application/json'

            # Lazily create the RunspacePool on the first real dispatch
            if (-not $pool) {
                $pool = [runspacefactory]::CreateRunspacePool(1, $ThrottleLimit)
                $pool.Open()
            }

            $ps = [powershell]::Create().AddScript($scriptBlock).AddArgument($Id).AddArgument($serialVal).AddArgument($headers)
            $ps.RunspacePool = $pool
            $handle = $ps.BeginInvoke()
            $jobs.Add([pscustomobject]@{ PS = $ps; Handle = $handle })
            $batchCount++
        }
    }
    end {
        foreach ($job in $jobs) {
            try {
                $result = $job.PS.EndInvoke($job.Handle)
                if ($result.Success) {
                    Write-Verbose "Reboot command successfully sent to Device $($result.Id)."
                } else {
                    Write-Error "Failed to restart device $($result.Id): $($result.Error)"
                }
            }
            finally {
                $job.PS.Dispose()
            }
        }
        if ($pool) {
            $pool.Close()
            $pool.Dispose()
        }
    }
}
