---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Get-BsnDevice

## SYNOPSIS
Fetches devices registered in the current BSN.cloud network.

## SYNTAX

### All (Default)
```
Get-BsnDevice [-Filter <String>] [-Sort <String>] [-Marker <String>] [-PageSize <Int32>]
 [-Connection <PSObject>] [<CommonParameters>]
```

### ById
```
Get-BsnDevice [-Id <Int32>] [-Connection <PSObject>] [<CommonParameters>]
```

### ByName
```
Get-BsnDevice [-Name <String>] [-Connection <PSObject>] [<CommonParameters>]
```

### BySerial
```
Get-BsnDevice [-Serial <String>] [-Connection <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Queries the BSN.cloud Devices API to retrieve player information.
Supports lookup
by ID (single API call), by name, or by serial number (client-side filtering on
a full paginated fetch).
Also supports standard BSN.cloud server-side filtering
via the Filter, Sort, Marker, and PageSize parameters.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Id
Fetch a single device by its numeric BSN.cloud ID.

```yaml
Type: Int32
Parameter Sets: ById
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Filter devices by name (matches settings.name or name).

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Serial
Filter devices by serial number.

```yaml
Type: String
Parameter Sets: BySerial
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
An expression for filtering search results server-side (e.g.
"\[model\] is 'HD1024'").

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sort
An expression for sorting the search results (e.g.
"\[lastModifiedDate\] asc").

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Marker
A value specifying which page to retrieve (nextMarker from previous response).

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
The maximum number of device instances that can be contained in the response.

```yaml
Type: Int32
Parameter Sets: All
Aliases:

Required: False
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

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS
