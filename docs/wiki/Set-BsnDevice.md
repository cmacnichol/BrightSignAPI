---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Set-BsnDevice

## SYNOPSIS
Updates a device registered in the BSN.cloud network.

## SYNTAX

```
Set-BsnDevice [-Id] <Int32> [-Body] <Object> [[-Connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Sends a PUT request to the BSN.cloud Devices API to update properties of a specific player.
Supports partial updates by accepting a hashtable or PSObject for the Body.

## EXAMPLES

### EXAMPLE 1
```
Set-BsnDevice -Id 12345 -Body @{ name = 'LobbyPlayer'; description = 'Main entrance' }
```

## PARAMETERS

### -Id
The numeric BSN.cloud ID of the device to update.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
A hashtable or object representing the fields to update (e.g.
@{ name = "NewName" }).

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
Position: 3
Default value: $script:BsnSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [pscustomobject] The updated device object returned by the API.
## NOTES

## RELATED LINKS
