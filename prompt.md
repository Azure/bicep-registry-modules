# Bicep Marketplace Gallery Image Module Generation

I have a project with the following directory structure:
```
bicep-registry-modules/
├── marketplace-gallery-image.json (JSON file with VM configuration data)
└── avm/
    └── res/
        └── azure-stack-hci/
            └── logical-network/ (directory with existing Bicep template structure)
```

## Objective
Create a complete marketplace-gallery-image Bicep module by transforming JSON configuration data into structured Bicep code, following existing AVM (Azure Verified Modules) patterns.

## Requirements

### 1. JSON to Bicep Transformation
- **Analyze marketplace-gallery-image.json** from the project root
- **Convert JSON data into structured Bicep code** with the following approach:
  - Identify related JSON properties that can be **grouped into logical structures/objects**
  - **Package related properties into Bicep user-defined types (UDTs)** or structured parameters
  - Create **reusable type definitions** for common configuration patterns
  - Transform flat JSON properties into **hierarchical Bicep structures** where appropriate

### 2. Module Architecture
- **Create main.bicep** as the primary module entry point
- Follow the **same architectural patterns and structure** as existing templates in logical-network/ directory
- Apply **AVM naming conventions, patterns, and module organization**
- Focus **exclusively on Bicep file generation** (.bicep files only)

### 3. Structure Analysis
Please analyze the existing logical-network/ directory to understand:
- Current **Bicep module patterns** and **naming conventions**
- **Parameter organization** and **type definitions**
- **Resource deployment patterns**
- **Module structure** and **file organization**
- **AVM compliance patterns**

### 4. Output Organization
Create the new module in the following structure:
```
bicep-registry-modules/
├── marketplace-gallery-image.json
└── avm/
    └── res/
        └── azure-stack-hci/
            ├── logical-network/
            └── marketplace-gallery-image/ (new folder)
                ├── main.bicep (primary module entry point)
                ├── [additional .bicep module files as needed]
                └── [any supporting .bicep files following logical-network patterns]
```

## Key Focus Areas
1. **JSON Structure Analysis**: Identify which JSON properties can be logically grouped into Bicep structures
2. **Type Definition Creation**: Create appropriate Bicep user-defined types for grouped properties
3. **Parameter Organization**: Structure module parameters using the identified types and structures
4. **AVM Pattern Compliance**: Ensure the generated module follows the same patterns as logical-network/
5. **Bicep Best Practices**: Apply proper Bicep syntax, conventions, and structural patterns

## Deliverables
- Complete **main.bicep** file with structured parameters and type definitions
- Any **additional .bicep files** needed to support the module architecture
- **Structured transformation** of JSON data into logical Bicep components
- **Full compliance** with existing AVM patterns observed in logical-network/

**Note**: Focus only on Bicep file generation. Do not create test files, documentation, or other non-Bicep files.
