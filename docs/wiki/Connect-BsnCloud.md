---
external help file: BrightSignAPI-help.xml
Module Name: BrightSignAPI
online version:
schema: 2.0.0
---

# Connect-BsnCloud

## SYNOPSIS
Authenticates to BSN.cloud using OAuth2 client-credentials and caches the session.

## SYNTAX

```
Connect-BsnCloud [-ClientId] <String> [-ClientSecret] <SecureString> [[-TokenUrl] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Performs a Keycloak client-credentials token request against BSN.cloud.
The resulting
access token and credentials are cached in a module-scoped session object so that
subsequent cmdlets can automatically re-authenticate when the short-lived token expires.

## EXAMPLES

### EXAMPLE 1
```
$secret = Read-Host "Client secret" -AsSecureString
```

$conn = Connect-BsnCloud -ClientId 'my-client-id' -ClientSecret $secret

## PARAMETERS

### -ClientId
Client ID generated in the BSN.cloud admin panel (https://adminpanel.bsn.cloud).

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

### -ClientSecret
Client secret as a SecureString.
Use Read-Host -AsSecureString to avoid plaintext in history.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TokenUrl
OAuth2 token endpoint URL.
Defaults to the standard BSN.cloud Keycloak endpoint.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $script:BsnConfig.TokenUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [pscustomobject] A BsnConnection object representing the authenticated session.
## NOTES

## RELATED LINKS
