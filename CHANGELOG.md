# Changelog
All notable changes to this project will be documented in this file.

## [0.3.1] - 2026-06-05
### Fixed
- Fixed an issue in `Connect-BsnCloud` where the auto-selected network connection object was being outputted to the pipeline twice.
- Removed the case-conflicting `New-BSNPlayer` alias which was breaking parameter autocompletion for `New-BsnPlayer` natively in PowerShell.

## [0.3.0] - 2026-06-04
### Added
- Implemented **B-Deploy Provision Records** support (`Get-BsnProvisionRecord`, `New-BsnProvisionRecord`, `Set-BsnProvisionRecord`, `Remove-BsnProvisionRecord`).
- Implemented **B-Deploy Setup Packages** support (`Get-BsnSetupPackage`, `New-BsnSetupPackage`, `Remove-BsnSetupPackage`) with full local/PKCS12 certificate injection (`internalCaArtifacts` and `clientCertificateArtifacts`).
- Added dynamic base-url routing to `Invoke-BsnApiRequest` via the `-ApiType` parameter to support `provision.bsn.cloud` alongside the Core `api.bsn.cloud`.
- Overhauled `New-BsnPlayer` to use robust native JSON parsing (`ConvertFrom-Json` / `ConvertTo-Json`) instead of fragile regex template replacements.
- Introduced the `-OverrideConfig` parameter to `New-BsnPlayer` allowing bulk injection of any arbitrary property into `setup.json`.

### Changed
- `New-BsnPlayer` now natively supports `.p12` certificate binding based on the structure of `wpaSettings` rather than strict visual order in the template.
- Removed legacy string-replacement helper `Set-BsnSetupValue.ps1`.
- Cleaned up JSON object properties for `setup.json` modifications to ensure complete structural validity on generation.

### Fixed
- Fixed an issue where `Get-BsnDeviceCount` returned `1` for scalar results due to PowerShell 7 treating `[int64]` elements as countable objects.
- Corrected ownership entity property in B-Deploy payload generation to strictly use `ClientId` instead of the non-existent `Username`.

## [0.2.0] - 2026-06-04
### Added
- Created `Assert-BsnNetworkSelected` to prevent obscure HTTP 403 errors when running cmdlets without a selected network.
- `Connect-BsnCloud` now automatically selects the user's BSN.cloud network if only one is available.
- Pester tests suite with initial API connection mocks.
- Standard GitHub module layout with `src/`, `tests/`, and `docs/`.
- `Disconnect-BsnCloud` cmdlet for session cleanup.
- Comment-based help for all public cmdlets.
- `[OutputType]` added to all public cmdlets.

### Changed
- Refactored `BrightSignAPI.psm1` into individual function files inside `Public/` and `Private/`.
- Overhauled `Restart-BsnDevice` for asynchronous batch rebooting using `RunspacePool`.
- `Connect-BsnCloud` returns a `BsnConnection` object, which is now accepted by all other cmdlets for multi-tenant support.
- Updated error handling to extract JSON payloads from BSN API responses instead of throwing generic HTTP errors.
- Added `[ValidateRange(1, 100)]` on `Restart-BsnDevice -ThrottleLimit`.
- *Assisted by AI.*

### Fixed
- Fixed alias export for `New-BSNPlayer` in manifest.
- Replaced internal UNC paths and PII in example data with generic placeholders.
- Fixed 404 error in `Get-BsnNetwork` by using the correct `/self/networks` API endpoint instead of the broken fallback `/self/session/networks`.
