---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Get-BsnProvisioningToken

## SYNOPSIS
Retrieves the currently valid BSN.cloud provisioning tokens.

## SYNTAX

```
Get-BsnProvisioningToken [[-Connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Sends a GET request to the BSN.cloud Provisioning API to retrieve setup tokens.

## EXAMPLES

### EXAMPLE 1
```
Get-BsnProvisioningToken
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

### [pscustomobject] Objects containing the provisioning token(s) and validity details.
## NOTES

## RELATED LINKS
