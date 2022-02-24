# Contributing to Bicep public registry

## Prerequisite

- Create a fork of the [Azure/bicep-registry-modules](https://github.com/Azure/bicep-registry-modules) repository and clone the fork to your local machine.
- Install [.NET 6.0 Runtime](https://dotnet.microsoft.com/en-us/download/dotnet/6.0/runtime)
  <!-- TODO: Add link to Nuget once the tool is published -->
- Install the [Bicep registry module]() .NET tool by running:
  - `dotnet tool install -g brm`

## Creating a new module

### Making a proposal

<!-- TODO: update the issue link -->

Before creating a new module, you must fill out this [issue template](https://github.com/Azure/bicep-registry-modules/issues/new) to make a proposal. Once the proposal is approved, proceed with the following steps. You should not send out a pull request to add a module without an associated approval as the pull request will be rejected.

### Creating a directory for the new module

<!-- TODO: need to discuss the pattern of the module path -->

Add a new directory under the `modules` folder in your local bicep-registry-modules repository with the path in lowercase following the pattern `<ModuleGroup>/<ModuleName>`. `<ModuleGroup>` can be any Azure resource provider name without the `Microsoft.` prefix. `<ModuleName>` should be a singular noun or noun phrase. Child modules should be placed side by side with parent modules to maintain a flat file structure. For examples:

- `compute/vm-with-public-ip`
- `web/containerized-web-app`
- `web/containerized-web-app-config`

### Generating module files

Open a terminal and navigate to the newly created folder. From there, run the following command to generate the required files for the Bicep public registry module:

```
brm generate
```

You should be able to see these files created in the module folder:
| File Name | Description |
| :--------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `metadata.json` | An JSON file containing module metadata. You must edit the file to provide the metadata values. |
| `main.bicep` | An empty Bicep file that you need to update. This is the main module file. |
| `test/main.test.bicep` | A Bicep file to be deployed in the PR merge validation pipeline to test if `main.bicep` is deployable. You must add at least one test to the file. A module referencing `main.bicep` is considered a test. |
| `main.json` | The main ARM template file compiled from `main.bicep`. This is the artifact that will be published to the Bicep public registry. You should not modify the file. |
| `README.md` | The README file generated based on the contents of `metadata.json` and `main.bicep`. You need to update this file to add examples. |
| `version.json` | The module version file. It is used together with `main.json` to calculate the patch version number of the module. Every time `main.json` is changed, the patch version number gets bumped. The full version (`<ModuleMajorVersion>.<ModuleMinorVersion>.<ModulePatchVersion>`) will then be assigned to the module before it gets published to the Bicep public module registry. The process is handled by the module publishing CI automatically. You should not edit this file. |

### Authoring module files

The files that you need to edit are `metadata.json`, `main.bicep`, `test/main.test.bicep`, `README.md`, and `version.json`.

The `metadata.json` file contains metadata of the module including `name`, `description`, and `owner`. You must provide the values for them. Below is a sample metadata file with the constraints of each property commented:

```JSONC
{
  "$schema": "https://aka.ms/bicep-registry-module-metadata-schema#",
  // The name of the module (10 - 60 characters).
  "name": "Sample module",
  // The description of the module (10 - 1000 characters).
  "description": "Sample module description",
  // The owner of the module. Must be a GitHub username or a team under the Azure organization
  "owner": "sampleusername"
}

```

The `main.bicep` file is the public interface of the module. When authoring `main.bicep`, make sure to provide a description for each parameter and output. You are free to create other Bicep files inside the module folder and reference them as local modules in `main.bicep` if needed. You may also reference other registry modules to help build your module. If you do so, make sure to add them as external references with specific version numbers. You should not reference other registry modules through local file path, since they may get updated overtime.

The `test/main.test.bicep` file is the test file for `main.bicep`. It will be deployed to a test environment in the PR merge pipeline to make sure `main.bicep` is deployable. You must add at least one test to the file. To add a test, simply create a module referencing `main.bicep` and provide values for the required parameters. You may write multiple tests to ensure different paths of the module are covered.

The `README.md` file is the documentation of the module. A large proportion of the file contents, such as the parameter and output tables, are generated based on the contents of other files. However, you must update the `Examples` section manually to provide examples of how the module can be used.

The `version.json` file defines the MAJOR and MINOR version number of the module. Update the value of the `“version"` property to specify a version, e.g., `"1.0"`.

Once you are done editing the files, run `brm generate` again to refresh `main.json` and `README.md`.

## Updating an existing module

To update an existing module, refer to the [Authoring module files](#authoring-module-files) section to update and regenerate the module files. Depending on the changes you make, you may need to bump the version in the `version.json` file.

### Bumping MAJOR version

You should bump the MAJOR version when you make breaking changes to the module. Anything that would violate the [Principle of least astonishment](https://en.wikipedia.org/wiki/Principle_of_least_astonishment) is considered a breaking change in the module. Below are some examples:

- Adding a new parameter with no default value
- Renaming a parameter
- Removing a parameter
- Change the type of a parameter
- Change the constraints of a parameter, including:
  - Remove a value from the allowed values array
  - Change a value in the allowed values array
  - Change the minimum or maximum length of the parameter
  - Change the minimum or maximum value of the parameter
  - Mark the parameter as secure
- Renaming an output
- Removing an output
- Change the type of an output
- Adding a new resource
- Removing a resource
- Bump the MAJOR version of a referenced public registry module

### Bumping MINOR version

You should increase the MINOR version when you change the module in a backward-compatible manner, including the following scenarios:

- Adding a new parameter with a default value
- Adding a new output
- Adding a new value to the allowed value array of a parameter

### Bumping PATCH version

If your change is non-breaking but does not require updating the MINOR version, the PATCH version should be increased, and it will be done by the CI automatically before publishing the module to the Bicep registry. The following scenarios will trigger a PATCH version bump:

- Updating the description of a parameter
- Updating the description of an output
- Adding a variable
- Removing a variable
- Renaming a variable
- Bump the API version of a resource
- Bump the MINOR or PATCH version of a referenced public registry module

## Validating a module

> Before running the command, don't forget to run `generate` to ensure all files are up-to-date.

You may use the Bicep registry module tool to validate the contents of the registry module files. To do so, invoke the follow command from the module folder:

```
brm validate
```

## Submitting a pull request

> The `brm validate` command does not deploy `test/main.test.bicep`, but it is highly recommended that you run a test deployment locally using Azure CLI or Azure PowerShell before submitting a pull request.

Once the module files are validated locally, you can commit your changes and open a pull request. You must link the new module proposal in the pull request description if you are trying to add a new module.

## Publishing a module

Once your pull request is approved and merged to the main, a CI job will be triggered to publish the module to the Bicep registry.
