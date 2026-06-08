---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Get-BsnDeviceCount

## SYNOPSIS
Gets the total number of devices registered in the current BSN.cloud network.

## SYNTAX

```
Get-BsnDeviceCount [[-Connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Queries the BSN.cloud Devices Count API to retrieve the total number of players.

## EXAMPLES

### EXAMPLE 1
```
Get-BsnDeviceCount
```

## PARAMETERS

### -Connection
A BsnConnection object returned by Connect-BsnCloud.
Defaults to the global session.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $script:BsnSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [int] The total number of devices.
## NOTES

## RELATED LINKS
