param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Module README example diagnostic directives' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')
    }

    It 'omits leaf-local directives without changing nested values or array boundaries' {
        $block = @'
    variables: [
      {
        name: 'TestInteger'
        // This fixture contains no secret.
        #disable-next-line use-secure-value-for-secure-inputs
        value: '500'
      }
      {
        name: 'TestBoolean'
        #disable-next-line use-secure-value-for-secure-inputs // Non-secret fixture.
        value: 'false'
      }
    ]
'@
        $result = ConvertTo-FormattedJSONParameterObject -BicepParamBlock $block

        $result.variables.value.Count | Should -Be 2
        $result.variables.value[0].name | Should -BeExactly 'TestInteger'
        $result.variables.value[0].value | Should -BeExactly '500'
        $result.variables.value[1].value | Should -BeExactly 'false'
    }

    It 'detects top-level parameters when a directive precedes the first parameter' {
        $block = @'
    #disable-next-line use-secure-value-for-secure-inputs
    content: 'public sample'
    name: 'assembly1'
'@
        $result = ConvertTo-FormattedJSONParameterObject -BicepParamBlock $block

        $result.Keys.Count | Should -Be 2
        $result.content.value | Should -BeExactly 'public sample'
        $result.name.value | Should -BeExactly 'assembly1'
    }

    It 'preserves directive-like text inside a string value' {
        $block = @'
    value: '#disable-next-line is literal test data'
'@
        $result = ConvertTo-FormattedJSONParameterObject -BicepParamBlock $block

        $result.value.value | Should -BeExactly '#disable-next-line is literal test data'
    }

    It 'preserves a directive-like line inside a real Bicep multiline string' {
        $block = @"
    // ''' in a comment does not open a multiline string.
    script: '''
#!/usr/bin/env bash
#disable-next-line is script data, not a Bicep directive
printf 'Keep // and quoted text'
'''
    #disable-next-line use-secure-value-for-secure-inputs
    content: 'public sample'
"@
        $expected = $block.Replace("    #disable-next-line use-secure-value-for-secure-inputs`n", '')

        $result = Remove-BicepDiagnosticDirectives -BicepParamBlock $block

        $result | Should -BeExactly $expected
    }
}
