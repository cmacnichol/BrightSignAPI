---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Get-BsnDeviceModelConnector

## SYNOPSIS
Fetches the list of connectors (e.g., HDMI, Audio) supported by a specific BrightSign model.

## SYNTAX

```
Get-BsnDeviceModelConnector [-Model] <String> [[-Connection] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Fetches the list of connectors (e.g., HDMI, Audio) supported by a specific BrightSign model.
This cmdlet interacts directly with the BSN.cloud REST API.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Model
The specific model name (e.g.
"XD1034").

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
A BsnConnection object.

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

## NOTES

## RELATED LINKS
