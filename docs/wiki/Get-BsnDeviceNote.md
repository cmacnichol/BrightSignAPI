---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Get-BsnDeviceNote

## SYNOPSIS
Fetches administrative notes for devices.

## SYNTAX

### ById (Default)
```
Get-BsnDeviceNote -DeviceId <Int32> [-Connection <PSObject>] [<CommonParameters>]
```

### All
```
Get-BsnDeviceNote [-All] [-Connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Fetches administrative notes for devices.
This cmdlet interacts directly with the BSN.cloud REST API.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -DeviceId
The numeric BSN.cloud ID of the device.

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

### -All
Switch to fetch notes for all devices instead of a specific one.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: True
Position: Named
Default value: False
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
Position: Named
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
