---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Set-BsnProvisionRecord

## SYNOPSIS
Modifies an existing B-Deploy provision record for a player.

## SYNTAX

```
Set-BsnProvisionRecord [-Id] <String> [-Serial] <String> [[-SetupName] <String>] [[-SetupId] <String>]
 [[-Url] <String>] [[-PlayerName] <String>] [[-Description] <String>] [[-Model] <String>]
 [[-Userdata] <String>] [[-Connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Sends a PUT request to B-Deploy (provision.bsn.cloud) to update a provision record.
The request body includes the same core properties as New-BsnProvisionRecord, plus the
record ID.

## EXAMPLES

### EXAMPLE 1
```
Set-BsnProvisionRecord -Id "1a2b3c..." -Serial "ABCD00000001" -Url "https://my.app/autorun.zip"
```

## PARAMETERS

### -Id
Unique 24-character identifier of the provision record to update (required).

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

### -Serial
The serial number of the player (required).

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

### -SetupName
The name of the setup package stored in B-Deploy to apply.

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

### -SetupId
The ID of the setup package stored in B-Deploy.
Required if SetupName is used.

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

### -Url
An external URL from which the player downloads its presentation (mutually exclusive with SetupName/SetupId).

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

### -PlayerName
Player name assigned during provisioning.

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

### -Description
Player description assigned during provisioning.

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

### -Model
The player model (e.g.
"XC4055").

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

### -Userdata
Additional custom setup package attributes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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
Position: 10
Default value: $script:BsnSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
