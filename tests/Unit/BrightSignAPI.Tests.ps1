$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Parent (Split-Path -Parent $here)) | Join-Path -ChildPath "src\BrightSignAPI\BrightSignAPI.psd1"

Describe "BrightSignAPI Module" {
    BeforeAll {
        Import-Module $sut -Force
    }

    It "Exports all expected public cmdlets" {
        $expectedCmdlets = @(
            'Connect-BsnCloud',
            'Disconnect-BsnCloud',
            'Select-BsnNetwork',
            'New-BsnProvisioningToken',
            'Remove-BsnProvisioningToken',
            'Test-BsnConnection',
            'New-BsnPlayer',
            'Get-BsnNetwork',
            'Get-BsnDevice',
            'Restart-BsnDevice'
        )

        $exported = Get-Command -Module BrightSignAPI -CommandType Function
        $diff = Compare-Object ($expectedCmdlets | Sort-Object) ($exported.Name | Sort-Object)
        $diff | Should BeNullOrEmpty
    }

    It "Exports the New-BSNPlayer alias" {
        $alias = Get-Alias New-BSNPlayer -ErrorAction SilentlyContinue
        $alias | Should Not BeNullOrEmpty
        $alias.Definition | Should Be 'New-BsnPlayer'
    }
}
