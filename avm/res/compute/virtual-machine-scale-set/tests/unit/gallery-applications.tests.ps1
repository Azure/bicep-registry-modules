param (
    [array] $moduleFolderPaths,
    [string] $repoRootPath
)

BeforeDiscovery {
    $applicationInputs = @(
        @{ Scenario = 'omitted'; Input = ''; Count = 0 },
        @{ Scenario = 'null'; Input = 'galleryApplications: null'; Count = 0 },
        @{ Scenario = 'empty'; Input = 'galleryApplications: []'; Count = 0 },
        @{
            Scenario = 'minimal'
            Input    = "galleryApplications: [{ packageReferenceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test/providers/Microsoft.Compute/galleries/test/applications/first/versions/1.0.0' }]"
            Count    = 1
        },
        @{
            Scenario = 'two applications'
            Input    = @'
galleryApplications: [
  {
    packageReferenceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test/providers/Microsoft.Compute/galleries/test/applications/first/versions/1.0.0'
    configurationReference: 'https://example.invalid/configuration'
    enableAutomaticUpgrade: false
    order: 0
    tags: 'first'
    treatFailureAsDeploymentFailure: false
  }
  {
    packageReferenceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test/providers/Microsoft.Compute/galleries/test/applications/second/versions/1.0.0'
    enableAutomaticUpgrade: false
    order: 1
    treatFailureAsDeploymentFailure: true
  }
]
'@
            Count    = 2
        }
    )
    $compilationCases = foreach ($os in @('Linux', 'Windows')) {
        foreach ($mode in @('Flexible', 'Uniform')) {
            foreach ($inputCase in $applicationInputs) {
                @{ OS = $os; Mode = $mode; Scenario = $inputCase.Scenario; ApplicationInput = $inputCase.Input; Count = $inputCase.Count }
            }
        }
    }
}

BeforeAll {
    $moduleRoot = Join-Path $repoRootPath 'avm/res/compute/virtual-machine-scale-set'
    $template = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.json') -Raw | ConvertFrom-Json -AsHashtable
    $vmss = $template.resources.vmss
    $applicationType = $template.definitions.vmGalleryApplicationType
}

Describe 'Gallery Applications contract' {
    It 'is an optional nullable array of the exported application type' {
        $template.parameters.galleryApplications.type | Should -Be 'array'
        $template.parameters.galleryApplications.nullable | Should -BeTrue
        $template.parameters.galleryApplications.items.'$ref' | Should -Be '#/definitions/vmGalleryApplicationType'
        $template.parameters.galleryApplications.ContainsKey('defaultValue') | Should -BeFalse
        $applicationType.metadata.'__bicep_export!' | Should -BeTrue
    }

    It 'requires only a string application version ID' {
        $applicationType.properties.packageReferenceId.type | Should -Be 'string'
        $applicationType.properties.packageReferenceId.nullable | Should -Not -BeTrue
        $applicationType.properties.Keys.Count | Should -Be 6
        foreach ($name in @('configurationReference', 'enableAutomaticUpgrade', 'order', 'tags', 'treatFailureAsDeploymentFailure')) {
            $applicationType.properties[$name].nullable | Should -BeTrue
        }
        $applicationType.properties.configurationReference.type | Should -Be 'string'
        $applicationType.properties.enableAutomaticUpgrade.type | Should -Be 'bool'
        $applicationType.properties.order.type | Should -Be 'int'
        $applicationType.properties.tags.type | Should -Be 'string'
        $applicationType.properties.treatFailureAsDeploymentFailure.type | Should -Be 'bool'
        $applicationType.properties.order.ContainsKey('minValue') | Should -BeFalse
    }

    It 'passes nonempty input through at the VMSS model path and otherwise emits null' {
        $vmss.apiVersion | Should -Be '2024-11-01'
        $vmss.properties.virtualMachineProfile.applicationProfile | Should -Be "[if(not(empty(parameters('galleryApplications'))), createObject('galleryApplications', parameters('galleryApplications')), null())]"
        $vmss.properties.ContainsKey('applicationProfile') | Should -BeFalse
        ($vmss.properties.virtualMachineProfile.extensionProfile | ConvertTo-Json -Depth 30) | Should -Not -Match 'galleryApplications'
    }
}

Describe 'Gallery Applications consumer compilation' {
    It 'accepts <Scenario> for <OS> with <Mode> orchestration' -ForEach $compilationCases {
        $modulePath = [IO.Path]::GetRelativePath($TestDrive, (Join-Path $moduleRoot 'main.bicep')).Replace('\', '/')
        $consumerPath = Join-Path $TestDrive 'consumer.bicep'
        # These synthetic inputs exercise the type contract, not deployable Azure dependencies.
        @"
module testDeployment '$modulePath' = {
  name: 'test'
  params: {
    name: 'test'
    adminUsername: 'testAdmin'
    adminPassword: ''
    imageReference: {}
    osDisk: { createOption: 'FromImage' }
    nicConfigurations: []
    osType: '$OS'
    orchestrationMode: '$Mode'
    skuName: 'Standard_D2s_v5'
    $ApplicationInput
  }
}
"@ | Set-Content -LiteralPath $consumerPath
        $compiled = bicep build $consumerPath --stdout
        $LASTEXITCODE | Should -Be 0
        $consumer = $compiled | Out-String | ConvertFrom-Json -AsHashtable
        $resources = if ($consumer.resources -is [System.Collections.IDictionary]) { $consumer.resources.Values } else { $consumer.resources }
        $deployment = @($resources | Where-Object type -EQ 'Microsoft.Resources/deployments')[0]
        $parameters = $deployment.properties.parameters

        if ($Scenario -eq 'omitted') {
            $parameters.ContainsKey('galleryApplications') | Should -BeFalse
        } elseif ($Scenario -eq 'null') {
            $parameters.ContainsKey('galleryApplications') | Should -BeTrue
            ($null -eq $parameters.galleryApplications.value) | Should -BeTrue
        } else {
            @($parameters.galleryApplications.value).Count | Should -Be $Count
        }
        if ($Scenario -eq 'minimal') {
            $parameters.galleryApplications.value[0].Keys.Count | Should -Be 1
        }
        if ($Scenario -eq 'two applications') {
            $first, $second = $parameters.galleryApplications.value
            $first.configurationReference | Should -Be 'https://example.invalid/configuration'
            $first.enableAutomaticUpgrade | Should -BeFalse
            $first.order | Should -Be 0
            $first.tags | Should -Be 'first'
            $first.treatFailureAsDeploymentFailure | Should -BeFalse
            $second.enableAutomaticUpgrade | Should -BeFalse
            $second.treatFailureAsDeploymentFailure | Should -BeTrue
            $second.order | Should -Be 1
            $first.packageReferenceId | Should -Not -Be $second.packageReferenceId
        }
    }
}
