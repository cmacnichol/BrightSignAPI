---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Restart-BsnDevice

## SYNOPSIS
Sends a reboot command to one or more BrightSign devices by ID.

## SYNTAX

```
Restart-BsnDevice [-Id] <Int32> [[-Connection] <PSObject>] [[-ThrottleLimit] <Int32>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Issues a remote reboot command to BrightSign players via the BSN.cloud REST API.
When multiple device IDs are piped in, requests are dispatched concurrently using a
RunspacePool for high throughput.
The token is refreshed mid-batch if it expires.

## EXAMPLES

### EXAMPLE 1
```
Restart-BsnDevice -Id 12345
```

### EXAMPLE 2
```
Get-BsnDevice | Restart-BsnDevice -ThrottleLimit 20
```

### EXAMPLE 3
```
1001, 1002, 1003 | Restart-BsnDevice
```

## PARAMETERS

### -Id
The numeric BSN.cloud device ID to reboot.
Accepts pipeline input.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
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

### -ThrottleLimit
Maximum number of concurrent reboot requests.
Defaults to 10.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 10
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
