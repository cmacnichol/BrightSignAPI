---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# New-BsnProvisioningToken

## SYNOPSIS
Creates a new BSN.cloud provisioning (registration) token.

## SYNTAX

```
New-BsnProvisioningToken [[-Connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
POSTs to the BSN.cloud Provisioning API to create a setup token.
This token is used
to register a new player with BSN.cloud on first boot.

## EXAMPLES

### EXAMPLE 1
```
$tokenInfo = New-BsnProvisioningToken
```

Write-Host "New token is: $($tokenInfo.token)"

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

### [pscustomobject] An object containing the provisioning token and validity details.
## NOTES

## RELATED LINKS
