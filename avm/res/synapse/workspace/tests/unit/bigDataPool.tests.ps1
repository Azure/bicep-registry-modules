param (
    [array] $moduleFolderPaths = @((Get-Item $PSScriptRoot).Parent.Parent.FullName),

    [string] $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $repoRootPath 'utilities/pipelines/sharedScripts/helper/Build-ViaRPC.ps1')

    $modulePath = Join-Path ($moduleFolderPaths | Sort-Object | Select-Object -First 1) 'main.bicep'
    $compiled = Build-ViaRPC -BicepFilePath $modulePath -PassThru -ErrorAction Stop
    $template = $compiled[$modulePath] | ConvertFrom-Json -AsHashtable
    $poolParameters = $template.resources.workspace_bigDataPools.properties.parameters
    $relativeModulePath = [System.IO.Path]::GetRelativePath($TestDrive, $modulePath).Replace('\', '/')
}

Describe 'Synapse workspace Big Data Pool inputs' {
    It 'requires nodeSize instead of accepting an input that fails during deployment' {
        $template.definitions.bigDataPoolType.properties.nodeSize.nullable | Should -Not -BeTrue

        $fixture = Join-Path $TestDrive 'missing-node-size.bicep'
        Set-Content -Path $fixture -Value @"
module workspace '$relativeModulePath' = {
  name: 'missing-node-size'
  params: {
    name: 'test-workspace'
    defaultDataLakeStorageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Storage/storageAccounts/teststorage'
    defaultDataLakeStorageFilesystem: 'test'
    sqlAdministratorLogin: 'testadmin'
    bigDataPools: [
      { name: 'test-pool' }
    ]
  }
}
"@
        $result = Build-ViaRPC -BicepFilePath $fixture -PassThru -ErrorAction SilentlyContinue -ErrorVariable compileErrors
        $result.ContainsKey($fixture) | Should -BeFalse
        ($compileErrors | Out-String) | Should -Match 'missing the following required properties: "nodeSize"'
    }

    It 'safely defaults an omitted or null nodeSizeFamily while preserving explicit values' {
        $poolParameters.nodeSizeFamily.value | Should -BeExactly "[tryGet(coalesce(parameters('bigDataPools'), createArray())[copyIndex()], 'nodeSizeFamily')]"
        $template.resources.workspace_bigDataPools.properties.template.parameters.nodeSizeFamily.defaultValue | Should -BeExactly 'MemoryOptimized'
        $poolParameters.nodeSize.value | Should -BeExactly "[coalesce(parameters('bigDataPools'), createArray())[copyIndex()].nodeSize]"
    }

    It 'compiles a pool with <scenario> nodeSizeFamily' -TestCases @(
        @{ scenario = 'omitted'; setting = '' }
        @{ scenario = 'null'; setting = 'nodeSizeFamily: null' }
        @{ scenario = 'explicit'; setting = "nodeSizeFamily: 'MemoryOptimized'" }
    ) {
        param ($setting)

        $fixture = Join-Path $TestDrive 'valid-pool.bicep'
        Set-Content -Path $fixture -Value @"
module workspace '$relativeModulePath' = {
  name: 'valid-pool'
  params: {
    name: 'test-workspace'
    defaultDataLakeStorageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Storage/storageAccounts/teststorage'
    defaultDataLakeStorageFilesystem: 'test'
    sqlAdministratorLogin: 'testadmin'
    bigDataPools: [
      {
        name: 'test-pool'
        nodeSize: 'Small'
        $setting
      }
    ]
  }
}
"@
        $result = Build-ViaRPC -BicepFilePath $fixture -PassThru -ErrorAction Stop
        $result[$fixture] | Should -Not -BeNullOrEmpty
    }
}
