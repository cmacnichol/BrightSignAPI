---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# New-BsnProvisionRecord

## SYNOPSIS
Creates a new B-Deploy provision record for a player.

## SYNTAX

```
New-BsnProvisionRecord [-Serial] <String> [[-SetupName] <String>] [[-SetupId] <String>] [[-Url] <String>]
 [[-PlayerName] <String>] [[-Description] <String>] [[-Model] <String>] [[-Userdata] <String>]
 [[-Connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Creates a provision record in B-Deploy (provision.bsn.cloud) linking a player serial
number to either a B-Deploy setup package or an external application URL.

## EXAMPLES

### EXAMPLE 1
```
New-BsnProvisionRecord -Serial "ABCD00000001" -SetupId "f2e1..." -SetupName "my setup package" -PlayerName "ProvisionTest"
```

## PARAMETERS

### -Serial
The serial number of the player (required).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupName
The name of the setup package stored in B-Deploy to apply.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupId
The ID of the setup package stored in B-Deploy.
Required if SetupName is used.

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

### -Url
An external URL from which the player downloads its presentation (mutually exclusive with SetupName/SetupId).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlayerName
Player name assigned during provisioning (overrides setup package values).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Player description assigned during provisioning.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Model
The player model (e.g.
"XC4055").

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Userdata
Additional custom setup package attributes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
Position: 9
Default value: $script:BsnSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
