Describe 'Integration Account child location outputs' {
    BeforeAll {
        $moduleRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
    }

    It '<Child> handles returned, missing and null resource locations safely' -ForEach @(
        @{ Child = 'agreement' }
        @{ Child = 'assembly' }
        @{ Child = 'certificate' }
        @{ Child = 'map' }
        @{ Child = 'partner' }
        @{ Child = 'schema' }
    ) {
        $templatePath = Join-Path $TestDrive "$Child.json"
        $diagnostics = & bicep build (Join-Path $moduleRoot "$Child/main.bicep") --no-restore --outfile $templatePath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $templatePath -Raw | ConvertFrom-Json -AsHashtable

        $resource = $template.resources[$Child]
        $assignedLocation = $resource.location.Trim('[', ']')
        $template.outputs.location.value | Should -BeExactly "[coalesce(tryGet(reference('$Child', '$($resource.apiVersion)', 'full'), 'location'), $assignedLocation)]"

        $source = Get-Content -LiteralPath (Join-Path $moduleRoot "$Child/main.bicep") -Raw
        $match = [regex]::Match($source, '(?m)^output location string = (?<expression>[^\r\n]+)')
        if (-not $match.Success) { throw "Missing location output expression for $Child." }
        $expression = $match.Groups['expression'].Value.Trim()
        $parameterPath = Join-Path $TestDrive "$Child.bicepparam"
        $parameterOutput = Join-Path $TestDrive "$Child-parameters.json"
        @(
            'using none'
            "var location = 'configured-region'"
            "var ${Child}Returned = { location: 'returned-region' }"
            "var ${Child}Missing = {}"
            "var ${Child}Null = { location: null }"
            "param returned = $($expression.Replace("$Child.", "${Child}Returned."))"
            "param missing = $($expression.Replace("$Child.", "${Child}Missing."))"
            "param nullLocation = $($expression.Replace("$Child.", "${Child}Null."))"
        ) -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = & bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $values = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
        $values.returned.value | Should -BeExactly 'returned-region'
        $values.missing.value | Should -BeExactly 'configured-region'
        $values.nullLocation.value | Should -BeExactly 'configured-region'
    }
}
