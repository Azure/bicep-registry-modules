param ([hashtable] $TestInputData)

Describe 'ACA-LZA native Notation image acceptance' {
    BeforeAll {
        $outputs = $TestInputData.DeploymentOutputs
        $sample = $outputs.testDeploymentOutputs.value.sampleImageVerification.value
        $verification = $outputs.notationVerification.value
    }

    It 'Deploys the same immutable image accepted by strict verification' {
        $sample.strictVerification | Should -BeTrue
        $sample.image | Should -Match '^.+/aca-lza/sample@sha256:[a-f0-9]{64}$'
        $verification.trustedAccepted | Should -BeTrue
        $verification.trustedImage | Should -BeExactly $sample.image
        $verification.privateKeyExported | Should -BeFalse
    }

    It 'Rejects unsigned, actually tampered and untrusted-root artifacts without treating transport failures as verification' {
        @($verification.controls).Count | Should -Be 3
        @($verification.controls.case | Sort-Object) | Should -Be @('Tampered', 'Unsigned', 'Untrusted')
        foreach ($control in $verification.controls) {
            $control.rejected | Should -BeTrue
            $control.errorSha256 | Should -Match '^[a-f0-9]{64}$'
        }
    }
}
