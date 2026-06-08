---
schema: 2.0.0
---

# Get-BsnSetupPackage

## SYNOPSIS
Retrieves B-Deploy setup packages.

## SYNTAX

```
Get-BsnSetupPackage [[-Id] <String>] [[-Connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Gets setup packages from the B-Deploy Setup API (provision.bsn.cloud/rest-setup/v3/setup/).
A Setup Package dictates firmware versions, timezones, logging rules, and certificate
installation for devices provisioned through B-Deploy.

## EXAMPLES

### EXAMPLE 1
```
Get-BsnSetupPackage
```

### EXAMPLE 2
```
Get-BsnSetupPackage -Id "f2e1d0c9..."
```

## PARAMETERS

### -Id
Unique identifier of the setup package to retrieve.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Position: 2
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
