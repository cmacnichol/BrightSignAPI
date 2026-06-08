---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Remove-BsnProvisionRecord

## SYNOPSIS
Removes a B-Deploy provision record for a player.

## SYNTAX

### ById (Default)
```
Remove-BsnProvisionRecord -Id <String> [-Connection <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### BySerial
```
Remove-BsnProvisionRecord -Serial <String> [-Connection <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Bulk
```
Remove-BsnProvisionRecord -IdList <String[]> [-Connection <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sends a DELETE request to B-Deploy (provision.bsn.cloud) to delete one or more
provision records.

## EXAMPLES

### EXAMPLE 1
```
Remove-BsnProvisionRecord -Id "1a2b3c..."
```

### EXAMPLE 2
```
Remove-BsnProvisionRecord -Serial "ABCD00000001"
```

### EXAMPLE 3
```
Remove-BsnProvisionRecord -IdList @("1a2b3c...", "9z8y7x...")
```

## PARAMETERS

### -Id
Unique identifier of the provision record to delete.

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
Serial number of the player whose provision record should be deleted.

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

### -IdList
An array of unique identifiers to delete in bulk.

```yaml
Type: String[]
Parameter Sets: Bulk
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

## NOTES

## RELATED LINKS
