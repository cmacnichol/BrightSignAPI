function Get-BsnErrorMessage {
    param([System.Management.Automation.ErrorRecord]$ErrorRecord)
    $msg = $ErrorRecord.Exception.Message
    if ($ErrorRecord.Exception -is [System.Net.WebException] -and $ErrorRecord.Exception.Response) {
        $stream = $null
        $reader = $null
        try {
            $stream = $ErrorRecord.Exception.Response.GetResponseStream()
            if ($stream.CanSeek) { $stream.Position = 0 }
            $reader = [System.IO.StreamReader]::new($stream)
            $body = $reader.ReadToEnd()
            $json = $body | ConvertFrom-Json
            if ($json.message) { $msg += " - $($json.message)" }
            elseif ($json.error_description) { $msg += " - $($json.error_description)" }
            elseif ($json.error) { $msg += " - $($json.error)" }
            else { $msg += " - Body: $body" }
        }
        catch {}
        finally {
            if ($reader) { $reader.Dispose() }
            # Do not dispose $stream here -- the StreamReader owns it
        }
    }
    return $msg
}
