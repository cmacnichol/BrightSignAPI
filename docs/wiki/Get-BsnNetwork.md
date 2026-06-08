---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Get-BsnNetwork

## SYNOPSIS
Lists the BSN.cloud networks available to the authenticated user.

## SYNTAX

```
Get-BsnNetwork [[-Connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Queries the BSN.cloud REST API for available networks.
Falls back to the
/self/session/networks endpoint if the primary endpoint is unavailable.

## EXAMPLES

### EXAMPLE 1
```
Get-BsnNetwork
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

### [pscustomobject] Network objects returned by the BSN.cloud API.
## NOTES

## RELATED LINKS
