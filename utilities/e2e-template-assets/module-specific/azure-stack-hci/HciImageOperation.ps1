function ConvertTo-HciImageBuildTimestamp {
    [CmdletBinding()]
    param ([Parameter(Mandatory)] [object] $Value)

    if ($Value -is [datetimeoffset] -or ($Value -is [datetime] -and $Value.Kind -ne [DateTimeKind]::Unspecified)) {
        return ([datetimeoffset] $Value).ToUniversalTime()
    }
    $timestamp = [datetimeoffset]::MinValue
    if ($Value -isnot [string] -or $Value -notmatch '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d{1,7})?(?:Z|[+-]\d{2}:\d{2})$' -or
        -not [datetimeoffset]::TryParse($Value, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref] $timestamp)) {
        throw 'An image build timestamp is missing its valid, absolute time-zone-qualified value.'
    }
    return $timestamp.ToUniversalTime()
}

function ConvertTo-HciPrivateValue {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Provider and Blob responses are wrapped in memory to prevent plaintext output between HCI helpers.')]
    [CmdletBinding()]
    param ([Parameter(Mandatory)] [AllowEmptyString()] [string] $Value)

    if ($Value.Length -eq 0) { return [securestring]::new() }
    return ConvertTo-SecureString $Value -AsPlainText -Force
}

function ConvertFrom-HciPrivateJson {
    [CmdletBinding()]
    param ([Parameter(Mandatory)] [securestring] $Value)

    function ConvertFrom-HciJsonToken {
        param ([Newtonsoft.Json.Linq.JToken] $Token)

        if ($Token -is [Newtonsoft.Json.Linq.JObject]) {
            $object = [System.Management.Automation.OrderedHashtable]::new()
            foreach ($property in $Token.Properties()) {
                $object.Add($property.Name, (ConvertFrom-HciJsonToken -Token $property.Value))
            }
            return $object
        }
        if ($Token -is [Newtonsoft.Json.Linq.JArray]) {
            $array = [object[]]::new($Token.Count)
            for ($index = 0; $index -lt $Token.Count; $index++) {
                $array[$index] = ConvertFrom-HciJsonToken -Token $Token[$index]
            }
            return ,$array
        }
        if ($Token -is [Newtonsoft.Json.Linq.JValue]) {
            return $Token.Value
        }
        throw 'Unsupported JSON value.'
    }

    try {
        $plain = [pscredential]::new('receipt', $Value).GetNetworkCredential().Password
        $settings = [Newtonsoft.Json.JsonSerializerSettings] @{
            DateParseHandling = 'None'
            TypeNameHandling = 'None'
            MetadataPropertyHandling = 'Ignore'
            CheckAdditionalContent = $true
            MaxDepth = 1024
        }
        $parsed = [Newtonsoft.Json.JsonConvert]::DeserializeObject($plain, $settings)
        if ($parsed -isnot [Newtonsoft.Json.Linq.JObject]) { throw 'Not an object.' }
        return ConvertFrom-HciJsonToken -Token $parsed
    } catch {
        throw 'The confidential HCI receipt is not a valid JSON object.'
    } finally {
        $plain = $null
        $parsed = $null
    }
}

function Get-HciImageOperationIdentity {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [securestring] $OperationUri,
        [Parameter(Mandatory)] [guid] $SubscriptionId,
        [Parameter(Mandatory)] [string] $Location
    )

    try {
        $plain = [pscredential]::new('operation', $OperationUri).GetNetworkCredential().Password
        $uri = $null
        $prefix = "/subscriptions/$SubscriptionId/providers/Microsoft.VirtualMachineImages/locations/$Location/operations/"
        if (-not [uri]::TryCreate($plain, [UriKind]::Absolute, [ref] $uri) -or
            $uri.Scheme -cne 'https' -or $uri.Host -cne 'management.azure.com' -or $uri.Port -ne 443 -or
            $uri.UserInfo -or $uri.Fragment -or $plain -match '[\s\\]' -or
            $plain -cnotmatch "^https://management\.azure\.com(?::443)?$([regex]::Escape($prefix))(?<id>[0-9a-fA-F-]{36})\?" -or
            $uri.AbsolutePath -cnotmatch "^$([regex]::Escape($prefix))(?<id>[0-9a-fA-F-]{36})$") {
            throw 'Invalid endpoint.'
        }
        $operationId = $Matches.id
        $parsedId = [guid]::Empty
        if (-not [guid]::TryParse($operationId, [ref] $parsedId) -or $parsedId -eq [guid]::Empty) {
            throw 'Invalid operation identity.'
        }
        $query = [System.Collections.Generic.Dictionary[string, string]]::new([StringComparer]::Ordinal)
        foreach ($part in $uri.Query.Substring(1).Split('&')) {
            $pair = $part.Split('=', 2)
            if ($pair.Count -ne 2 -or -not $pair[1] -or
                $pair[0] -cnotin @('api-version', 't', 'c', 's', 'h') -or
                -not $query.TryAdd($pair[0], $pair[1])) {
                throw 'Invalid query.'
            }
        }
        if ($query['api-version'] -cne '2025-10-01' -or $query.Count -notin @(1, 5)) {
            throw 'Unsupported query.'
        }
        return $operationId
    } catch {
        throw 'The image operation URI is outside the supported endpoint and query contract; its outcome is uncertain. Do not resubmit.'
    } finally {
        $plain = $null
        $uri = $null
        $query = $null
    }
}

function Get-HciImageOperationHash {
    [CmdletBinding()]
    param ([Parameter(Mandatory)] [securestring] $OperationUri)

    $bytes = [Text.Encoding]::UTF8.GetBytes([pscredential]::new('operation', $OperationUri).GetNetworkCredential().Password)
    try {
        return [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes)).ToLowerInvariant()
    } finally {
        [Array]::Clear($bytes)
    }
}

function New-HciHttpClient {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Creates only a disposable in-memory HTTP client; no network request or resource mutation.')]
    [CmdletBinding()]
    param ([Parameter(Mandatory)] [int] $TimeoutSeconds)

    $handler = [System.Net.Http.HttpClientHandler]::new()
    $handler.AllowAutoRedirect = $false
    $handler.UseCookies = $false
    $client = [System.Net.Http.HttpClient]::new($handler)
    $client.Timeout = [timespan]::FromSeconds($TimeoutSeconds)
    return $client
}

function Invoke-HciImageOperationRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [ValidateSet('GET', 'POST')] [string] $Method,
        [Parameter(Mandatory)] [securestring] $Uri
    )

    $token = $null
    $client = $null
    $request = $null
    $response = $null
    $result = @{}
    try {
        $token = (Get-AzAccessToken -ResourceUrl 'https://management.azure.com/' -AsSecureString -ErrorAction Stop).Token
        if ($token -isnot [securestring] -or $token.Length -eq 0) { throw 'Missing ARM token.' }
        $client = New-HciHttpClient -TimeoutSeconds 120
        $uriOptions = [System.UriCreationOptions]::new()
        $uriOptions.DangerousDisablePathAndQueryCanonicalization = $true
        $requestUri = [uri]::new([pscredential]::new('operation', $Uri).GetNetworkCredential().Password, [ref] $uriOptions)
        $request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::new($Method), $requestUri)
        $request.Headers.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::new(
            'Bearer', [pscredential]::new('token', $token).GetNetworkCredential().Password
        )
        $response = $client.SendAsync($request).GetAwaiter().GetResult()
        $result = @{
            StatusCode = [int] $response.StatusCode
            Body = ConvertTo-HciPrivateValue ($response.Content.ReadAsStringAsync().GetAwaiter().GetResult())
            RetryAfterSeconds = 15
        }
        foreach ($name in @('Azure-AsyncOperation', 'Location')) {
            $values = $null
            if ($response.Headers.TryGetValues($name, [ref] $values)) {
                if (@($values).Count -ne 1 -or [string]::IsNullOrEmpty(@($values)[0])) {
                    throw 'Ambiguous operation header.'
                }
                $result[$name] = ConvertTo-HciPrivateValue @($values)[0]
            }
        }
        $retryValues = $null
        if ($response.Headers.TryGetValues('Retry-After', [ref] $retryValues) -and
            (@($retryValues).Count -ne 1 -or $null -eq $response.Headers.RetryAfter)) {
            throw 'Invalid Retry-After header.'
        }
        if ($response.Headers.RetryAfter.Delta) {
            $result.RetryAfterSeconds = [Math]::Max(1, [int] [Math]::Ceiling($response.Headers.RetryAfter.Delta.TotalSeconds))
        } elseif ($response.Headers.RetryAfter.Date) {
            $result.RetryAfterSeconds = [Math]::Max(1, [int] [Math]::Ceiling(($response.Headers.RetryAfter.Date - [datetimeoffset]::UtcNow).TotalSeconds))
        }
        return $result
    } catch {
        foreach ($value in $result.Values) {
            if ($value -is [securestring]) { $value.Dispose() }
        }
        throw "The HCI image $Method request could not be confirmed. No automatic retry was attempted; do not resubmit a build."
    } finally {
        $requestUri = $null
        if ($response) { $response.Dispose() }
        if ($request) { $request.Dispose() }
        if ($client) { $client.Dispose() }
        if ($token -is [securestring]) { $token.Dispose() }
    }
}
