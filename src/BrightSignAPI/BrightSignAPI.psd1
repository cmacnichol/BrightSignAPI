@{
    RootModule        = 'BrightSignAPI.psm1'
    ModuleVersion     = '0.3.4'
    GUID              = 'b1d4e7c2-9a3f-4c2e-8d6a-0f1e2a3b4c5d'
    Author            = 'Christopher Macnichol'
    Description       = 'Provisions BrightSign signage players: fetches a BSN.cloud registration token via the Provisioning API (OAuth2 client-credentials) and clones a reference setup folder, rewriting only the per-player values in setup.json.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Connect-BsnCloud',
        'Disconnect-BsnCloud',
        'Select-BsnNetwork',
        'Get-BsnProvisionRecord',
        'New-BsnProvisionRecord',
        'Set-BsnProvisionRecord',
        'Remove-BsnProvisionRecord',
        'Get-BsnSetupPackage',
        'New-BsnSetupPackage',
        'Remove-BsnSetupPackage',
        'Get-BsnProvisioningToken',
        'New-BsnProvisioningToken',
        'Remove-BsnProvisioningToken',
        'Test-BsnConnection',
        'New-BsnPlayer',
        'Get-BsnNetwork',
        'Get-BsnDevice',
        'Restart-BsnDevice',
        'Get-BsnDeviceCount',
        'Set-BsnDevice',
        'Remove-BsnDevice',
        'Get-BsnDeviceError',
        'Get-BsnDeviceDownload',
        'Get-BsnDeviceScreenshot',
        'Get-BsnDeviceTag',
        'Add-BsnDeviceTag',
        'Remove-BsnDeviceTag',
        'Get-BsnDeviceNote',
        'Set-BsnDeviceNote',
        'Get-BsnDevicePermission',
        'Set-BsnDevicePermission',
        'Remove-BsnDevicePermission',
        'Get-BsnDeviceOperation',
        'Get-BsnDeviceModel',
        'Get-BsnDeviceModelConnector',
        'Get-BsnDeviceModelVideoMode'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags         = @('BrightSign', 'BSN', 'Signage', 'API', 'REST')
            LicenseUri   = 'https://github.com/cmacnichol/BrightSignAPI/blob/main/LICENSE'
            ProjectUri   = 'https://github.com/cmacnichol/BrightSignAPI'
            ReleaseNotes = 'Restructured module to standard GitHub layout. Assisted by AI.'
        }
    }
}