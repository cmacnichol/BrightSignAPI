---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Select-BsnNetwork

## SYNOPSIS
Selects the active BSN.cloud network for subsequent API calls.

## SYNTAX

### ByName (Default)
```
Select-BsnNetwork -NetworkName <String> [-Connection <PSObject>] [<CommonParameters>]
```

### ById
```
Select-BsnNetwork -NetworkId <Int32> [-Connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Sends a PUT request to set the active network on the BSN.cloud session.
This must be
called after Connect-BsnCloud.
The module automatically re-selects the network whenever
it refreshes an expired access token.

## EXAMPLES

### EXAMPLE 1
```
Select-BsnNetwork -NetworkName 'Production'
```

### EXAMPLE 2
```
Select-BsnNetwork -NetworkId 42 -Connection $myConn
```

## PARAMETERS

### -NetworkName
The name of the network to select.

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkId
The numeric ID of the network to select.

```yaml
Type: Int32
Parameter Sets: ById
Aliases:

Required: True
Position: Named
Default value: 0
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

### [pscustomobject] The updated BsnConnection object.
## NOTES

## RELATED LINKS
