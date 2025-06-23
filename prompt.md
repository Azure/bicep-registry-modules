I have a project with the following directory structure:
bicep-registry-modules/
├── marketplace-gallery-image.json (JSON file with VM configuration data)
└── avm/
    └── res/
        └── azure-stack-hci/
            └── logical-network/ (directory with existing Bicep template structure)

Please help me create a complete marketplace-gallery-image module with two distinct components:

**Component 1: Module Code**
- Create main.bicep as the primary module entry point
- Transform the configuration data from marketplace-gallery-image.json (located in project root) into Bicep module code
- Follow the same architectural pattern and structure as the existing templates in the logical-network/ directory

**Component 2: Test Code**
- Create test files similar to those in the logical-network/ directory
- The test code should be based on the azlocal module foundation, just like the logical-network tests
- Generate marketplace-gallery-image resources on top of the azlocal module infrastructure
- Follow the same testing patterns and conventions used in logical-network/

Important: Please organize all the generated content in a new folder called marketplace-gallery-image/ at the same level as logical-network/. The structure should be:
bicep-registry-modules/
├── marketplace-gallery-image.json
└── avm/
    └── res/
        └── azure-stack-hci/
            ├── logical-network/
            └── marketplace-gallery-image/ (new folder)
                ├── main.bicep (module entry point)
                ├── [additional module files]
                └── [test files following logical-network test patterns]

Please analyze the existing Bicep templates and test structure in the logical-network/ directory to understand:
1. Current patterns, naming conventions, and module organization used in the AVM (Azure Verified Modules) structure
2. How tests are structured and how they utilize the azlocal module as foundation
3. Testing patterns and conventions

Then create the complete folder structure and files for marketplace-gallery-image/ that integrates with the existing architecture, including both the module code (transformed from JSON) and comprehensive test code (based on azlocal module foundation).
