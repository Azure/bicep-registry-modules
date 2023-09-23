Describe "Custom Test" {

    It "Should pass" {
        $true | Should -Be $true
    }

    It "Should fail" {
        $false | Should -Be $true
    }
}