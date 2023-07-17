# Contributing to Bicep public registry

> We only accept pull requests created by Microsoft employees for now. External customers can make proposals or report bugs by opening an [issue](https://github.com/Azure/bicep-registry-modules/issues).

The following instructions are created to help with the development of Bicep public registry modules.

## Prerequisite

- Create a fork of the [Azure/bicep-registry-modules](https://github.com/Azure/bicep-registry-modules) repository and clone the fork to your local machine.
- Install [.NET 7.0 Runtime](https://dotnet.microsoft.com/en-us/download/dotnet/7.0/runtime)
- Install the [Bicep registry module](https://www.nuget.org/packages/Azure.Bicep.RegistryModuleTool/) tool by running:
  - `dotnet tool install --global Azure.Bicep.RegistryModuleTool`

> A GitHub Codespace is available which is preconfigured with all of these prerequisites.

## Creating a new module

### Making a proposal

Before creating a new module, you must fill out this [issue template](https://github.com/Azure/bicep-registry-modules/issues/new?assignees=&labels=Module+Proposal&template=module_proposal.yml&title=%5BModule+Proposal%5D%3A+) to make a proposal. Each module needs to have its own proposal. Please avoid including multiple modules in one issue. Once the proposal is approved, proceed with the following steps. You should not send out a pull request to add a module without an associated approval as the pull request will be rejected.

### Creating a directory for the new module

Add a new directory under the `modules` folder in your local bicep-registry-modules repository with the path in lowercase following the pattern `<ModuleGroup>/<ModuleName>`. Typical `<ModuleGroup>` names are Azure resource provider names without the `Microsoft.` prefix, but other names are also allowed as long as they make sense. `<ModuleName>` should be a singular noun or noun phrase. Child modules should be placed side by side with parent modules to maintain a flat file structure. For examples:

- `compute/vm-with-public-ip`
- `web/containerized-web-app`
- `web/containerized-web-app-config`

### Generating module files

> Before generating module files, please make sure both Bicep CLI and Bicep registry module tool installed on your machine are up-to-date. This is to avoid any file content outdated errors in the pull request validation CI, since the CI always uses the latest versions of Bicep CLI and Bicep registry module tool.

Open a terminal and navigate to the newly created folder. From there, run the following command to generate the required files for the Bicep public registry module:

```
brm generate
```

You should be able to see these files created in the module folder:
| File Name | Description |
| :--------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `main.bicep` | An empty Bicep file that you need to update. This is the main module file. You must edit the "metadata" statements to provide the module name, description and owner. |
| `test/main.test.bicep` | A Bicep file to be deployed in the PR merge validation pipeline to test if `main.bicep` is deployable. You must add at least one test to the file. A module referencing `main.bicep` is considered a test. |
| `main.json` | The main ARM template file compiled from `main.bicep`. This is the artifact that will be published to the Bicep public registry. You should not modify the file. |
| `README.md` | The README file generated based on the contents of `main.bicep`. You need to update this file to add examples. |
| `version.json` | The module version file. It is used together with `main.json` to calculate the patch version number of the module. Every time `main.json` is changed, the patch version number gets bumped. The full version (`<ModuleMajorVersion>.<ModuleMinorVersion>.<ModulePatchVersion>`) will then be assigned to the module before it gets published to the Bicep public module registry. The process is handled by the module publishing CI automatically. You should not edit this file. |

NOTE: The `metadata.json` file is now obsolete. Running `brm generate` will automatically remove this file and place its contents into the main.bicep file as `metadata` statements (see below).

### Authoring module files

The files that you need to edit are `main.bicep`, `test/main.test.bicep`, `README.md`, and `version.json`.

#### `main.bicep`

The `main.bicep` file is the public interface of the module. When authoring `main.bicep`, make sure to provide a description for each parameter and output. You are free to create other Bicep files inside the module folder and reference them as local modules in `main.bicep` if needed. You may also reference other registry modules to help build your module. If you do so, make sure to add them as external references with specific version numbers. You should not reference other registry modules through local file path, since they may get updated overtime. The `main.bicep` most follow various static code analysis checks, such as including descriptions on every parameter and output. This will be used to automatically generate the `README.md`.

```bicep
metadata name = 'Sample module'
metadata description = '''Sample module description. This should be a short description of the functionality of the module.
A more detailed description can be included in the README.md file.'''
metadata owner = 'sampleusername'

@description('Deployment Location')
param location string = resourceGroup().location

@description('Prefix of Resource Name. Not used if name is provided')
param prefix string = 'pre'

@minLength(3)
@maxLength(INT)
@description('Name of the Resource')
param name string = take('${prefix}-${uniqueString(resourceGroup().id, location)}', INT)

resource resource 'Microsoft.Resource/resource@latest-version' = {
  name: name
  location: location
  properties: {
    ...
  }
}

@description('Resource Name')
output name string = name

@description('Resource Id')
output id string = resource.id
```

We try to maintain the consistencies demostrated above.

Each template should include the following 3 parameters: `location`, `prefix` and `name`; and following 2 outputs: `name` and `id`.

##### Parameters

- The `location` parameter is set to `resourceGroup().location` in only the `main.bicep`, and should be required when present in nested templates.
- The `prefix` should use the recommended abbreviations collected [here](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations).
- The `name` should include a min and max length constraint. It should also generate a unique name for the user, that will remain the same when redeployed with the same parameters, such as with `uniqueString(resourceGroup().id, location)`. If multiple resources are including in a module, the default values of other names should be based on this value.

##### Outputs

- The `name` output should link to the `name` parameter.
- THe `id` output should link to the main resource of the deployment. Additional ID parameters may be provided.

##### Zone Redudancy

Including an option to enable Zone Redudancy is recommended, but not required. When it is included, it should be enabled using the following parameter.

```bicep
@description('Flag to indicate whether or not this region is an AvailabilityZone region')
param isZoneRedundant bool = false
```

##### Virtual Network

Including Virtual Network is also recommended. This support should be designed with the Virtual-Network module in the repository.

#### `main.test.bicep`

The `test/main.test.bicep` file is the test file for `main.bicep`. It will be deployed to a test environment in the PR merge pipeline to make sure `main.bicep` is deployable. You must add at least one test to the file. To add a test, simply create a module referencing `main.bicep` and provide values for the required parameters. You may write multiple tests to ensure different paths of the module are covered. If any of the parameters are secrets, make sure to provide generated values instead of hard-coded ones. If additional resources are required, they should be included in a `prereq.test.bicep` file in the same directory. Additional test files may be provided that follow the format, `<test-name>.test.bicep`. Below is an example showing how to use the combination of some string functions to construct a dynamic azure-compatible password for a virtual machine:

```bicep
param location string = resourceGroup().location

//Prerequisites
// module prereq 'prereq.test.bicep' = {
//   name: 'test-prereqs'
//   params: {
//     location: location
//   }
// }

@secure()
param vmPasswordSuffix string = uniqueString(newGuid())

var vmPassword = 'pwd#${vmPasswordSuffix}'

module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    vmUsername: 'testuser'
    vmPassword: vmPassword
  }
}
```

The `README.md` file is the documentation of the module. A large proportion of the file contents, such as the parameter and output tables, are generated based on the contents of other files. However, you must update the `Description` and `Examples` sections manually, to provide a detailed description for the module and examples of how the module can be used.

The `version.json` file defines the MAJOR and MINOR version number of the module. Update the value of the `“version"` property to specify a version, e.g., `"1.0"`.

Once you are done editing the files, run `brm generate` again to refresh `main.json` and `README.md`.

## Nested Bicep Files

Nested bicep files should be placed into a folder `modules`, for example `modules/nested.bicep`.
Additional nested folders may be created, only if the nested directory contain multiple files.

Avoid the following:

- `./main.bicep`
- `./modules/storage/main.bicep`
- `./modules/compute/main.bicep`

Instead go with:

- `./main.bicep`
- `./modules/storage.bicep`
- `./modules/compute.bicep`

## User-Defined Types (Preview)

The repository has been setup to leverage the preview feature, [user-defined types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types), on a per module basis.

While the feature is in Preview, [to enable](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types#enable-the-preview-feature) include a `bicepconfig.json` in your module directory.

`type` assignments should be declared to the end of the file, after the declaration of `outputs`. Types should include descriptions, which can be copied from the Azure API documentation when wrapping existing RP objects. Nested `type` declarations do not need a description. `type` should be reserved for use in complex cases and should not be used to in place of primitive types.

```bicep
@description('The properties of a storage account’s Blob service.')
type blobServiceProperties = {
  changeFeed: changeFeed?
  containerDeleteRetentionPolicy: containerDeleteRetentionPolicy?
  cors: cors?
  deleteRetentionPolicy: deleteRetentionPolicy?
  isVersioningEnabled: isVersioningEnabled?
  lastAccessTimeTrackingPolicy: lastAccessTimeTrackingPolicy?
  restorePolicy: restorePolicy?
}

@description('The blob service properties for change feed events.')
type changeFeed = {
  enabled: boo
  @minValue(1)
  @maxValue(146000)
  retentionInDays: int?
}

@description('The blob service properties for container soft delete.')
type containerDeleteRetentionPolicy = {
  allowPermanentDelete: bool
  @minValue(1)
  @maxValue(365)
  days: int?
  enabled: bool
}
```

Avoid these patterns.

```bicep
type enabled = bool  // Avoid setting aliases for primitive types
type retentionInDays = int

@description('The properties of a storage account’s Blob service.')
type blobServiceProperties = {
  @description('The blob service properties for change feed events.')
  changeFeed: {
    enabled: enabled

    @minValue(1)
    @maxValue(146000)
    retentionInDays: retentionInDays?
  }?

  // Avoid nesting complex type definitions
  @description('The blob service properties for container soft delete.')
  containerDeleteRetentionPolicy: {
    allowPermanentDelete: bool
    @minValue(1)
    @maxValue(365)
    days: int?
    enabled: bool
  }?

  cors: cors?
  deleteRetentionPolicy: deleteRetentionPolicy?
  isVersioningEnabled: isVersioningEnabled?
  lastAccessTimeTrackingPolicy: lastAccessTimeTrackingPolicy?
  restorePolicy: restorePolicy?
}
```

## Updating an existing module

To update an existing module, refer to the [Authoring module files](#authoring-module-files) section to update and regenerate the module files. Depending on the changes you make, you may need to bump the version in the `version.json` file.

### Bumping MAJOR version

You should bump the MAJOR version when you make breaking changes to the module. Anything that would violate the [Principle of least astonishment](https://en.wikipedia.org/wiki/Principle_of_least_astonishment) is considered a breaking change in the module. Below are some examples:

- Adding a new parameter with no default value
- Renaming a parameter
- Removing a parameter
- Changing the type of a parameter
- Changing the default value of a parameter
- Changing the constraints of a parameter, including:
  - Removing a value from the allowed values array
  - Changing a value in the allowed values array
  - Changing the minimum or maximum length of the parameter
  - Changing the minimum or maximum value of the parameter
  - Marking the parameter as secure
- Renaming an output
- Removing an output
- Change the type of an output
- Adding a new resource
- Removing a resource
- Bumping the MAJOR version of a referenced public registry module

### Bumping MINOR version

You should increase the MINOR version when you change the module in a backward-compatible manner, including the following scenarios:

- Adding a new parameter with a default value
- Adding a new output
- Adding a new value to the allowed value array of a parameter

### Bumping PATCH version

If your change is non-breaking but does not require updating the MINOR version, the PATCH version will be bumped by the CI automatically when publishing the module to the Bicep registry once your pull request is merged. The PATCH version is increased by the git commit "height" since last time the `main.json` file of a module was changed on the `main` branch. Because we only allow squash merging, the git commit height is always 1 for each module update PR merged into `main`. The following scenarios will trigger a PATCH version bump:

- Updating the bicep file
- Updating the description of a parameter
- Updating the description of an output
- Adding a variable
- Removing a variable
- Renaming a variable
- Bumping the API version of a resource
- Bumping the MINOR or PATCH version of a referenced public registry module

## Validating module files

> Before running the command, don't forget to run `generate` to ensure all files are up-to-date.

You may use the Bicep registry module tool to validate the contents of the registry module files. To do so, invoke the follow command from the module folder:

```
brm validate
```

## Running deployment tests

The `brm validate` command mentioned in the above step does not deploy the `test/main.test.bicep` file. Instead, it will be deployed to a temporary resource group as part of the pull request merge validation CI pipeline once you submit a pull request. However, due to security limitations, the CI pipeline won't deploy the test file if the module's target scope is `subscription`, `managementGroup`, or `tenant`. In such cases, you must run test deployments locally using Azure CLI or Azure Powershell before submitting a pull request.

## Submitting a pull request

Once the module files are validated locally, you can commit your changes and open a pull request. You must link the new module proposal in the pull request description if you are trying to add a new module. Adding or updating multiple modules is not supported and will cause a failure in the pull request validation CI, so please only add or change one module at a time.

## Prefix the PR TItle based on the type of change.

The modules in the repository follow Semantic Versioning.
A GitHub action checks that PRs include a prefix. This acts as a stepping stone to automating the version incrementing, this action requires each PR have a semantic prefix.

Example PR Tiles:

- Creating a new module: `feat(new): Storage Account Module`
- Add a bug fix to existing module: `fix: Storage Account does not properly format output`
- Add a feature to existing module `feat: Add input parameter to deploy storage into vnet`
- Add a breaking change to a module due to refactoring: `refactor!: Use custom types in storage account`

More details can be found [here] about each prefix(https://www.conventionalcommits.org/en/v1.0.0/).

Recommend prefixes include:

- fix:
- feat:
- build:
- chore:
- ci:
- docs:
- style:
- refactor:
- perf:
- test:

### Optional: Enable Auto Generation with GitHub Actions

Enable optional GitHub Workflows in your fork to enable auto-generation of assets with our [GitHub Action](/.github/workflows/push-auto-generate.yml).
In order to trigger GitHub Actions after auto-generation, [add a GitHub PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) as a secret in your forked repository called `PAT`.
This `PAT` should NOT include the `workflow` scope.

## Publishing a module

Once your pull request is approved and merged to the `main` branch, a GitHub workflow will be triggered to publish the module to the Bicep registry automatically.
