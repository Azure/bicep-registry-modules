<h1 style="color: steelblue;">⚠️ Upcoming changes ⚠️</h1>

To provide our customers with a unified experience, Azure Verified Modules ([AVM](https://aka.ms/AVM)) will become the single Microsoft standard for Bicep modules, published to the Public Bicep Registry, via this repository.

Going forward, new modules will be need to be developed and published in accordance with the [AVM specifications](https://azure.github.io/Azure-Verified-Modules/specs/module-specs/). Module proposals for new, non-AVM modules will no longer be accepted. To propose a new AVM module, you can file a Module Proposal, [here](https://aka.ms/AVM/ModuleProposal).

Existing non-AVM modules will be retired or migrated to AVM. To provide continued access for existing customers, non-AVM modules formerly published in the registry will be kept there indefinitely, but their source code will be replaced with an informational notice and a pointer to their successor in AVM, when applicable. Over time, VS code intellisense support for the old, non-AVM modules will also be removed - while existing references will keep working.

The AVM core team will orchestrate this transition, starting with developing a migration/retirement plan together with the owners of the modules impacted.

For the list of available and planned AVM modules, please visit the [AVM Module Index](https://aka.ms/AVM/ModuleIndex) pages.

# Bicep Registry Modules

This repo contains the source code of all currently available Bicep modules in the Bicep public module registry.

## Available Modules

To view available modules and their versions, go to Bicep Registry Module Index ([https://aka.ms/br-module-index](https://aka.ms/br-module-index)).

## Contributing

We only accept contributions from Microsoft employees at this time. Teams within Microsoft can refer to [Contributing to Bicep public registry](./CONTRIBUTING.md) for information on contributing modules. External customers can propose new modules or report bugs by opening an [issue](https://github.com/Azure/bicep-registry-modules/issues).

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
