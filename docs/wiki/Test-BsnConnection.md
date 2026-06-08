---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Test-BsnConnection

## SYNOPSIS
Runs a full smoke test of the BSN.cloud authentication and provisioning flow.

## SYNTAX

### ByName (Default)
```
Test-BsnConnection -ClientId <String> -ClientSecret <SecureString> -NetworkName <String> [-KeepToken]
 [<CommonParameters>]
```

### ById
```
Test-BsnConnection -ClientId <String> -ClientSecret <SecureString> -NetworkId <Int32> [-KeepToken]
 [<CommonParameters>]
```

## DESCRIPTION
Performs a four-step connectivity test: authenticate, select network, create a
provisioning token, and (optionally) revoke the test token.
Reports PASS/FAIL
for each step.
Useful for validating credentials and network access.

## EXAMPLES

### EXAMPLE 1
```
$secret = Read-Host "Secret" -AsSecureString
```

Test-BsnConnection -ClientId 'my-id' -ClientSecret $secret -NetworkName 'Production' -Verbose

## PARAMETERS

### -ClientId
BSN.cloud API client ID.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
BSN.cloud API client secret as a SecureString.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkName
Name of the network to test against.

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkId
Numeric ID of the network to test against.

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

### -KeepToken
If specified, the provisioning token created during the test is kept rather than revoked.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [pscustomobject] An array of objects with Step, Result, and Detail properties.
## NOTES

## RELATED LINKS
