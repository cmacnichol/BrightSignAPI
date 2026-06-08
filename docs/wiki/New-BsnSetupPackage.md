---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# New-BsnSetupPackage

## SYNOPSIS
Creates a new B-Deploy setup package.

## SYNTAX

### Basic
```
New-BsnSetupPackage -PackageName <String> [-TimeZone <String>] [-InternalCaArtifacts <Object[]>]
 [-ClientCertificateArtifacts <Object[]>] [-Connection <PSObject>] [<CommonParameters>]
```

### Raw
```
New-BsnSetupPackage -Body <Hashtable> [-Connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
POSTs a new setup package to B-Deploy (provision.bsn.cloud).
The setup package
defines how players are configured during cloud provisioning, including timezones,
firmware updates, logging, and internal CA certificates (for 802.1x networks).

## EXAMPLES

### EXAMPLE 1
```
$p12Bytes = [System.IO.File]::ReadAllBytes("C:\certs\client.p12")
```

$clientCerts = @(
    @{ 
        name = "MyClientCert"
        asset = \[Convert\]::ToBase64String($p12Bytes)
        passphrase = "mySecretPassword"
    }
)
New-BsnSetupPackage -PackageName "VLAN-Setup-1" -ClientCertificateArtifacts $clientCerts

## PARAMETERS

### -PackageName
The unique name for this setup package within your BSN.cloud network (required).

```yaml
Type: String
Parameter Sets: Basic
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeZone
The timezone the player should operate in (e.g.
"America/New_York").

```yaml
Type: String
Parameter Sets: Basic
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InternalCaArtifacts
An array of CA certificate objects (hashtables) with a 'name' and 'asset'.
Example: @( @{ name = "MyRootCA"; asset = "-----BEGIN CERTIFICATE-----..." } )

```yaml
Type: Object[]
Parameter Sets: Basic
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientCertificateArtifacts
An array of client certificate objects (.p12) with a 'name', 'asset' (base64 string),
and optionally a 'passphrase'.

```yaml
Type: Object[]
Parameter Sets: Basic
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
A hashtable containing the full raw Setup Package JSON structure.
Useful for advanced
configurations not covered by explicit parameters.

```yaml
Type: Hashtable
Parameter Sets: Raw
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
A BsnConnection object returned by Connect-BsnCloud.
Defaults to the global session.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $script:BsnSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [pscustomobject] The created setup package entity.
## NOTES

## RELATED LINKS
