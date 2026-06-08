---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# New-BsnPlayer

## SYNOPSIS
Clones a reference BrightSign player folder and configures it for a new device.

## SYNTAX

```
New-BsnPlayer [-Name] <String> [-SourceFolder] <String> [[-DestinationRoot] <String>]
 [[-RegistrationToken] <String>] [[-MacEthernet] <String>] [[-MacWiFi] <String>]
 [[-EncryptedCertPass] <String>] [[-Description] <String>] [[-UnitNamingMethod] <String>]
 [[-LocalDwsUserName] <String>] [[-LocalDwsPassword] <String>] [[-SSID] <String>]
 [[-CertificatesDirectory] <String>] [[-OverrideConfig] <Hashtable>] [[-Connection] <PSObject>]
 [-SkipLargeFiles] [-Force] [[-OutResultFile] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Copies an existing "golden" player folder, then parses setup.json natively to inject
per-device values (name, registration token, certificates, network priority).
Automatically fetches a provisioning token from BSN.cloud if one is not supplied.

Supports pipeline input for batch provisioning from CSV files.

## EXAMPLES

### EXAMPLE 1
```
New-BsnPlayer -Name 'LobbyPlayer' -SourceFolder '\\server\share\Template' -MacEthernet 'aabbccddeeff'
```

## PARAMETERS

### -Name
New player name (e.g.
LobbyDisplay01).
Updates unitName and hostnames.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name_BSN, Device Name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SourceFolder
Path to an existing, working player folder to clone.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationRoot
Where the new player folder is created.
Defaults to the source folder's parent.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RegistrationToken
BSN.cloud registration token.
If omitted, one is auto-fetched via New-BsnProvisioningToken.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -MacEthernet
Ethernet MAC address.
Used to map the correct certificate and set network priority.

```yaml
Type: String
Parameter Sets: (All)
Aliases: MAC_Ethernet

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -MacWiFi
WiFi MAC address.
Used to map the correct certificate and set network priority.

```yaml
Type: String
Parameter Sets: (All)
Aliases: MAC_WiFi

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EncryptedCertPass
Pre-encrypted certificate passphrase for EAP-TLS authentication.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
A custom description for the player.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UnitNamingMethod
The unit naming method (e.g.
'unitNameOnly' or 'appendUnitIDToUnitName').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LocalDwsUserName
The local Diagnostic Web Server username.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LocalDwsPassword
The local Diagnostic Web Server password.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SSID
The WiFi SSID to connect to if using a wireless network.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CertificatesDirectory
Directory containing .p12 certificate files.
Defaults to .\Certificates under the module root.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OverrideConfig
A hashtable of key-value pairs to override any arbitrary property in the setup.json meta.client block.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Position: 15
Default value: $script:BsnSession
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipLargeFiles
Skip copying large firmware files (*.bsfw) for dry runs.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Overwrite the destination folder if it already exists.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutResultFile
Path to a CSV file.
If specified, appends a record of the generated player configuration to this file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [pscustomobject] An object containing details of the provisioned player.
## NOTES

## RELATED LINKS
