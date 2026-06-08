---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Get-BsnProvisionRecord

## SYNOPSIS
Retrieves B-Deploy provision records for players.

## SYNTAX

### List (Default)
```
Get-BsnProvisionRecord [-PageNum <Int32>] [-PageSize <Int32>] [-Connection <PSObject>] [<CommonParameters>]
```

### ById
```
Get-BsnProvisionRecord -Id <String> [-Connection <PSObject>] [<CommonParameters>]
```

### BySerial
```
Get-BsnProvisionRecord -Serial <String> [-Connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Gets provision records from the B-Deploy API (provision.bsn.cloud).
A provision record
links a physical player (by serial number) to a Setup Package, allowing automated
provisioning when the player boots.

## EXAMPLES

### EXAMPLE 1
```
Get-BsnProvisionRecord -Serial "X1E234567890"
```

### EXAMPLE 2
```
Get-BsnProvisionRecord -PageNum 1 -PageSize 20
```

## PARAMETERS

### -Id
Unique identifier of the provision record to retrieve.

```yaml
Type: String
Parameter Sets: ById
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Serial
Serial number of the player to retrieve the provision record for.

```yaml
Type: String
Parameter Sets: BySerial
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageNum
Page index to retrieve (default 0 or 1 depending on API).

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Maximum number of provision records on a page.

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 20
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

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS
