function New-BsnPlayer {
<#
.SYNOPSIS
    Clones a reference BrightSign player folder and configures it for a new device.

.DESCRIPTION
    Copies an existing "golden" player folder, then parses setup.json natively to inject
    per-device values (name, registration token, certificates, network priority).
    Automatically fetches a provisioning token from BSN.cloud if one is not supplied.

    Supports pipeline input for batch provisioning from CSV files.

.PARAMETER Name
    New player name (e.g. LobbyDisplay01). Updates unitName and hostnames.

.PARAMETER SourceFolder
    Path to an existing, working player folder to clone.

.PARAMETER DestinationRoot
    Where the new player folder is created. Defaults to the source folder's parent.

.PARAMETER RegistrationToken
    BSN.cloud registration token. If omitted, one is auto-fetched via New-BsnProvisioningToken.

.PARAMETER MacEthernet
    Ethernet MAC address. Used to map the correct certificate and set network priority.

.PARAMETER MacWiFi
    WiFi MAC address. Used to map the correct certificate and set network priority.

.PARAMETER EncryptedCertPass
    Pre-encrypted certificate passphrase for EAP-TLS authentication.

.PARAMETER CertificatesDirectory
    Directory containing .p12 certificate files. Defaults to .\Certificates under the module root.

.PARAMETER OverrideConfig
    A hashtable of key-value pairs to override any arbitrary property in the setup.json meta.client block.

.PARAMETER Connection
    A BsnConnection object returned by Connect-BsnCloud. Defaults to the global session.

.PARAMETER SkipLargeFiles
    Skip copying large firmware files (*.bsfw) for dry runs.

.PARAMETER Force
    Overwrite the destination folder if it already exists.

.OUTPUTS
    [pscustomobject] An object with Name, Path, and RegistrationToken properties.

.EXAMPLE
    New-BsnPlayer -Name 'LobbyPlayer' -SourceFolder '\\server\share\Template' -MacEthernet 'aabbccddeeff'
#>
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias('New-BSNPlayer')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Name_BSN', 'Device Name')]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [string] $SourceFolder,

        [string] $DestinationRoot,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $RegistrationToken,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('MAC_Ethernet')]
        [string] $MacEthernet,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('MAC_WiFi')]
        [string] $MacWiFi,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $EncryptedCertPass,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $Description,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('unitNameOnly','appendUnitIDToUnitName')]
        [string] $UnitNamingMethod,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $LocalDwsUserName,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $LocalDwsPassword,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $SSID,

        [string] $CertificatesDirectory,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [hashtable] $OverrideConfig,

        [psobject] $Connection = $script:BsnSession,

        [switch] $SkipLargeFiles,

        [switch] $Force
    )

    process {
        if ([string]::IsNullOrWhiteSpace($CertificatesDirectory)) {
            $CertificatesDirectory = Join-Path $PSScriptRoot 'Certificates'
        }

        if (-not (Test-Path -LiteralPath $SourceFolder)) {
            throw "SourceFolder not found: $SourceFolder"
        }

        # 0. Pre-validate Certificates (if provided)
        if (-not [string]::IsNullOrWhiteSpace($EncryptedCertPass) -and (-not [string]::IsNullOrWhiteSpace($MacEthernet) -or -not [string]::IsNullOrWhiteSpace($MacWiFi))) {
            $certsToTest = @()
            if (-not [string]::IsNullOrWhiteSpace($MacEthernet)) { $certsToTest += Join-Path $CertificatesDirectory "$($MacEthernet).p12" }
            if (-not [string]::IsNullOrWhiteSpace($MacWiFi)) { $certsToTest += Join-Path $CertificatesDirectory "$($MacWiFi).p12" }

            foreach ($certPath in $certsToTest) {
                if (Test-Path -LiteralPath $certPath) {
                    try {
                        $certObj = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($certPath, $EncryptedCertPass)
                        $certObj.Dispose()
                    } catch {
                        throw "Certificate validation failed for '$certPath'. The file may be corrupt or the EncryptedCertPass is incorrect. $($_.Exception.Message)"
                    }
                }
            }
        }

        if (-not $DestinationRoot) {
            $DestinationRoot = Split-Path -Parent $SourceFolder
            if (-not $DestinationRoot) {
                throw "Cannot determine DestinationRoot from SourceFolder '$SourceFolder'."
            }
        }
        
        $dest = Join-Path $DestinationRoot $Name
        if (Test-Path -LiteralPath $dest) {
            if ($Force) {
                Write-Verbose "Destination exists, but -Force is present. Wiping $dest."
                Remove-Item -LiteralPath $dest -Recurse -Force
            } else {
                throw "Destination already exists: $dest  (refusing to overwrite without -Force)"
            }
        }

        if (-not $PSCmdlet.ShouldProcess($dest, "Clone $SourceFolder and configure player '$Name'")) {
            return
        }

        # 1. Fetch a token if not supplied
        if (-not $RegistrationToken) {
            Write-Verbose 'No token supplied; requesting one from BSN.cloud.'
            $RegistrationToken = New-BsnProvisioningToken -Connection $Connection
        }

        # 2. Clone the folder
        $excludes = @()
        if ($SkipLargeFiles) { $excludes = @('*.bsfw') }
        Copy-Item -LiteralPath $SourceFolder -Destination $dest -Recurse
        if ($SkipLargeFiles) {
            Get-ChildItem -LiteralPath $dest -Recurse -Include $excludes | Remove-Item -Force
        }

        # 3. Parse setup.json natively
        $setupPath = Join-Path $dest 'setup.json'
        if (-not (Test-Path -LiteralPath $setupPath)) {
            throw "Cloned folder has no setup.json at $setupPath"
        }
        
        $setupObj = Get-Content -LiteralPath $setupPath -Raw | ConvertFrom-Json

        # Apply primary overrides
        if ($setupObj.meta.client) {
            $setupObj.meta.client.unitName = $Name
            $setupObj.meta.client.hostname = $Name

            if ($PSBoundParameters.ContainsKey('Description')) {
                $setupObj.meta.client.unitDescription = $Description
            }
            if ($PSBoundParameters.ContainsKey('UnitNamingMethod')) {
                $setupObj.meta.client.unitNamingMethod = $UnitNamingMethod
            }
            if ($PSBoundParameters.ContainsKey('LocalDwsUserName')) {
                $setupObj.meta.client.lwsUserName = $LocalDwsUserName
            }
            if ($PSBoundParameters.ContainsKey('LocalDwsPassword')) {
                $setupObj.meta.client.lwsPassword = $LocalDwsPassword
            }
            if ($PSBoundParameters.ContainsKey('SSID')) {
                $setupObj.meta.client.ssid = $SSID
            } elseif (-not [string]::IsNullOrWhiteSpace($MacWiFi)) {
                if ([string]::IsNullOrWhiteSpace($setupObj.meta.client.ssid)) {
                    throw "No SSID specified for '$Name' (which has a WiFi MAC), and the template setup.json does not contain a valid SSID fallback."
                }
            }
        }
        if ($setupObj.meta.server) {
            $setupObj.meta.server.bsnRegistrationToken = $RegistrationToken
        }
        if ($setupObj.meta.network) {
            $setupObj.meta.network.hostname = $Name
        }

        # Apply Certificate Logic (wpaSettings_2 = Wired, wpaSettings = Wireless)
        if (-not [string]::IsNullOrWhiteSpace($EncryptedCertPass)) {
            if ($setupObj.meta.client.wpaSettings_2) {
                $setupObj.meta.client.wpaSettings_2.eapCertificatePassphrase = $EncryptedCertPass
            }
            if ($setupObj.meta.client.wpaSettings) {
                $setupObj.meta.client.wpaSettings.eapCertificatePassphrase = $EncryptedCertPass
            }
        }

        if (-not [string]::IsNullOrWhiteSpace($MacEthernet) -or -not [string]::IsNullOrWhiteSpace($MacWiFi)) {
            # Network Priority
            if (-not [string]::IsNullOrWhiteSpace($MacEthernet)) {
                $setupObj.meta.client.networkConnectionPriorityWired = 0
                $setupObj.meta.client.networkConnectionPriorityWireless = 1
            } else {
                $setupObj.meta.client.networkConnectionPriorityWired = 1
                $setupObj.meta.client.networkConnectionPriorityWireless = 0
            }

            # Map certificates
            if (-not [string]::IsNullOrWhiteSpace($MacEthernet) -and $setupObj.meta.client.wpaSettings_2) {
                $setupObj.meta.client.wpaSettings_2.eapCertificateFileName = "$($MacEthernet).p12"
            }
            if (-not [string]::IsNullOrWhiteSpace($MacWiFi) -and $setupObj.meta.client.wpaSettings) {
                $setupObj.meta.client.wpaSettings.eapCertificateFileName = "$($MacWiFi).p12"
            }
        }

        # Apply custom overrides
        if ($OverrideConfig) {
            foreach ($key in $OverrideConfig.Keys) {
                if ($null -ne $setupObj.meta.client.$key) {
                    $setupObj.meta.client.$key = $OverrideConfig[$key]
                } else {
                    $setupObj.meta.client | Add-Member -MemberType NoteProperty -Name $key -Value $OverrideConfig[$key]
                }
            }
        }

        # Write back cleanly
        $setupObj | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $setupPath -Encoding UTF8

        # 4. Handle Certificates (Physical File Swap)
        if (-not [string]::IsNullOrWhiteSpace($MacEthernet) -or -not [string]::IsNullOrWhiteSpace($MacWiFi)) {
            Get-ChildItem -LiteralPath $dest -Filter "*.p12" | Remove-Item -Force -ErrorAction SilentlyContinue
            
            if (-not [string]::IsNullOrWhiteSpace($MacEthernet)) {
                $ethCert = Join-Path $CertificatesDirectory "$($MacEthernet).p12"
                if (Test-Path -LiteralPath $ethCert) {
                    Copy-Item -LiteralPath $ethCert -Destination $dest -Force
                } else {
                    Write-Warning "Ethernet certificate not found at: $ethCert"
                }
            }
            
            if (-not [string]::IsNullOrWhiteSpace($MacWiFi)) {
                $wifiCert = Join-Path $CertificatesDirectory "$($MacWiFi).p12"
                if (Test-Path -LiteralPath $wifiCert) {
                    Copy-Item -LiteralPath $wifiCert -Destination $dest -Force
                } else {
                    Write-Warning "WiFi certificate not found at: $wifiCert"
                }
            }
        }

        Write-Verbose "Created player '$Name' at $dest"

        return [pscustomobject]@{
            Name              = $Name
            Path              = $dest
            RegistrationToken = $RegistrationToken
        }
    }
}
