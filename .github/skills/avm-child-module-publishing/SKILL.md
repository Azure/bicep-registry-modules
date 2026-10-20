---
name: avm-child-module-publishing
description: "Publish AVM Bicep child modules to the Bicep public registry. Example prompt: Publish a child module for avm/res/<resource provider>/<resource type>/<child resource>. This skill covers the full end-to-end workflow: prerequisite verification, allowed-list registration, telemetry instrumentation, version file creation, changelog updates, parent module updates, and final validation. USE FOR: publish child module, add child module telemetry, child module version.json, child module CHANGELOG, child module allowed list, bicep child module publishing. DO NOT USE FOR: creating new child module functionality (use AVM-Plan/AVM-Implement agents), publishing top-level parent modules, Terraform modules."
---

# AVM Bicep Child Module Publishing

> **AUTHORITATIVE GUIDANCE — MANDATORY COMPLIANCE**
>
> This skill implements the official AVM Bicep Child Module Publishing workflow from Azure Verified Modules. Follow these steps exactly. Do not skip or reorder steps.

---

## Context

Child resources exist only within the scope of another resource (e.g., a subnet within a virtual network). In AVM, child modules deploy these child resources and live inside their parent module's folder structure. By default, child modules are **not** independently published — they must be explicitly published.

Publishing a child module does **not** move or reorganize any files. The child module stays in its existing folder within the parent.

> **Important**: This process is currently in pilot/preview phase. Only resource modules (`avm/res/`) are supported. Pattern and utility modules are not supported.

---

## Workflow

Follow instructions in the [AVM Bicep Child Module Publishing](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/child-module-publishing/) documentation for the full step-by-step process, including code snippets and file templates.
