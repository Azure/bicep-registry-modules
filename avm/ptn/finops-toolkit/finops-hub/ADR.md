# Architecture Decision Records (ADR)

This document captures the key architecture and design decisions made for the FinOps Hub AVM module.

> **ADR Format**: This log follows [Microsoft Well-Architected Framework ADR guidance](https://learn.microsoft.com/azure/well-architected/architect-role/architecture-decision-record) and [adr.github.io](https://adr.github.io/) conventions.
>
> **📚 FinOps Hub Docs**: [Microsoft Learn - FinOps Hubs](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/finops-hubs-overview)

### ADR Template

Each ADR follows this structure:
- **Date**: When the decision was made
- **Status**: `Proposed` | `Accepted` | `Deprecated` | `Superseded by ADR-XXX`
- **Context**: Problem statement and why a decision is needed
- **Decision**: What was decided
- **Options Considered**: Alternatives evaluated (with pros/cons)
- **Consequences**: Positive and negative implications
- **Confidence**: `High` | `Medium` | `Low` (optional - for uncertain decisions)

---

## Engineering Summary

This module represents the culmination of feedback from enterprise customers deploying FinOps solutions at scale. Key engineering principles:

| Principle | Implementation |
|-----------|----------------|
| **Separation of concerns** | Storage (ingestion) → ADX/Fabric (analytics) → Power BI (visualization) |
| **Multi-cloud from day one** | FOCUS schema enables Azure, AWS, GCP, OCI in single data model |
| **Enterprise-ready defaults** | WAF-aligned mode, managed identities, network isolation options |
| **Accessible for all** | Demo mode for PAYGO tenants; test data generators & dashboards available from [FinOps Toolkit](https://aka.ms/finops/toolkit) |
| **Infrastructure focus** | This AVM module deploys Azure infrastructure only; analytics, reporting, and visualization are maintained in the [official FinOps Toolkit](https://aka.ms/finops/toolkit) (see ADR-014) |

### Customer Feedback Incorporated

- **"We need to start small and scale"** → Storage-only mode, Dev/Test ADX SKUs
- **"Security team requires private endpoints"** → Managed VNet option with automatic PE provisioning
- **"We have data from multiple clouds"** → FOCUS normalization; multi-cloud test data available from [FinOps Toolkit](https://aka.ms/finops/toolkit)
- **"FinOps team needs real-time data"** → ADX with auto-refresh; dashboards available from [FinOps Toolkit](https://aka.ms/finops/toolkit)
- **"Business users prefer Power BI"** → Clear guidance on connecting official FinOps Toolkit reports

---

## FinOps Foundation Alignment

This module aligns with the [FinOps Foundation Framework](https://www.finops.org/framework/) and official terminology:

| FinOps Concept | Implementation | Reference |
|----------------|----------------|-----------|
| **FinOps Domains** | Dashboard pages organized by Inform, Optimize, Operate | [FinOps Domains](https://www.finops.org/framework/domains/) |
| **FinOps Capabilities** | KQL functions mapped to capabilities (Anomaly Management, Rate Optimization, etc.) | [FinOps Capabilities](https://www.finops.org/framework/capabilities/) |
| **FOCUS Specification** | Native FOCUS 1.0r2 schema for cost normalization | [FOCUS Spec](https://focus.finops.org/) |
| **FinOps Personas** | Dashboard designed for Practitioners, Engineers, Executives | [FinOps Personas](https://www.finops.org/framework/personas/) |

### FOCUS Use Cases Implemented

The KQL functions implement official [FOCUS Use Cases](https://focus.finops.org/use-cases/):

- ✅ Identify anomalous daily spending by subaccount and region
- ✅ Compare resource usage month over month
- ✅ Identify unused capacity reservations
- ✅ Determine Effective Savings Rate (ESR)
- ✅ Report commitment discount purchases
- ✅ Analyze tag coverage for cost allocation

---

## ADR-001: Pattern Module Classification

**Date**: February 2026
**Status**: Accepted
**Context**: Determine the appropriate AVM module classification for FinOps Hub.

**Decision**: Classify as a **Pattern Module (ptn)** rather than a Resource Module (res).

**Rationale**:
- FinOps Hub orchestrates multiple Azure resources (Storage, ADX, ADF, Key Vault, Network)
- Implements a complete solution rather than wrapping a single Azure resource
- Aligns with other solution accelerators in `avm/ptn/sa/*`
- Pattern modules can compose resource modules and add business logic

**Consequences**:
- Module path: `avm/ptn/finops-toolkit/finops-hub`
- More flexibility in parameter design
- Expected to provide opinionated defaults for the use case

---

## ADR-002: Azure Data Explorer as Primary Analytics Engine

**Date**: February 2026
**Status**: Accepted
**Context**: Select the primary analytics platform for cost data analysis.

**Decision**: Use **Azure Data Explorer (ADX)** as the primary analytics engine.

**Alternatives Considered**:
| Option | Pros | Cons |
|--------|------|------|
| ADX | Near real-time, KQL native, cost-effective at scale | Learning curve for KQL |
| Synapse Analytics | SQL familiar, integrated | Higher cost, slower for time-series |
| Databricks | ML capabilities, Spark | Overkill for FinOps, complex |
| Log Analytics | Already in most tenants | 30-day default retention, query limits |

**Rationale**:
- ADX excels at time-series data (cost data is inherently time-series)
- Native KQL provides powerful analytical capabilities
- Cost-effective for petabyte-scale data
- Supports ingestion from multiple sources (Blob, Event Hub)
- FinOps Toolkit has mature KQL function library

**Consequences**:
- ADX cluster is optional but recommended for analytics
- Storage-only mode available for Power BI-only scenarios
- KQL expertise required for custom analytics

---

## ADR-003: FOCUS Specification Alignment

**Date**: February 2026
**Status**: Accepted
**Context**: Determine the data schema for cost normalization.

**Decision**: Align with **FOCUS (FinOps Open Cost and Usage Specification) 1.0r2**.

**Rationale**:
- Industry standard for cloud cost data normalization
- Enables multi-cloud analysis (Azure, AWS, GCP, OCI)
- Supported by FinOps Foundation and major cloud providers
- Azure Cost Management exports FOCUS-compliant data natively

**Key Schema Elements**:
```
BilledCost, EffectiveCost, ListCost, ContractedCost
ChargePeriodStart, ChargePeriodEnd, BillingPeriodStart
ProviderName, PublisherName, PublisherCategory
ServiceName, ServiceCategory, ResourceId, ResourceName
CommitmentDiscountId, CommitmentDiscountType, CommitmentDiscountStatus
```

**Consequences**:
- All KQL functions use FOCUS column names
- Custom columns prefixed with `x_` (e.g., `x_SkuDescription`)
- Multi-cloud data can be unified in single Costs table

---

## ADR-004: Dual Deployment Mode Support

**Date**: February 2026
**Status**: Accepted
**Context**: Support both enterprise and demo/development scenarios.

**Decision**: Implement **Enterprise Mode** and **Demo Mode** with automatic detection.

**Enterprise Mode** (EA/MCA billing):
- Automated Cost Management exports
- ADF pipelines for data ingestion
- Full price sheet and reservation data

**Demo Mode** (PAYGO/Dev):
- Test data generation scripts
- Realistic FOCUS-compliant sample data
- Multi-cloud scenarios for demos

**Detection Logic**:
```
billingAccountType == 'ea' | 'mca' | 'mpa' → Enterprise Mode
billingAccountType == 'paygo' | 'csp' → Demo Mode
billingAccountType == 'auto' → Detect from scopesToMonitor
```

**Rationale**:
- Many customers cannot create exports (PAYGO, CSP, Visual Studio)
- Demo mode enables POCs without production billing access
- Same analytics experience in both modes

**Consequences**:
- `src/` folder contains test data generators
- Outputs include mode-specific guidance
- Documentation covers both paths

---

## ADR-005: Managed Virtual Network Option

**Date**: February 2026
**Status**: Accepted
**Context**: Provide network isolation options for enterprise security requirements.

**Decision**: Offer three network isolation modes: **None**, **Managed**, and **BringYourOwn**.

| Mode | Description | Use Case |
|------|-------------|----------|
| None | Public endpoints | Dev/Test, demos |
| Managed | Module creates VNet, private endpoints, DNS | Production without existing network |
| BringYourOwn | Customer provides VNet, subnets | Enterprise with hub-spoke topology |

**Rationale**:
- Many enterprises require private endpoints
- ADX Managed VNet simplifies network configuration
- Flexibility for different organizational network topologies

**Consequences**:
- Additional parameters: `networkIsolationMode`, `existingVNetId`, `subnetId`
- Managed mode creates: VNet, subnets, private endpoints, private DNS zones
- Increased deployment time for managed network (~10-15 min)

---

## ADR-006: AVM Standard Interface Implementation

**Date**: February 2026
**Status**: Accepted
**Context**: Ensure compliance with AVM module requirements.

**Decision**: Implement all required AVM standard interfaces.

**Implemented Interfaces**:
| Interface | Implementation |
|-----------|----------------|
| `enableTelemetry` | Standard AVM telemetry via deployment PID |
| `lock` | Applied to Storage, Key Vault, ADF, ADX |
| `diagnosticSettings` | Forwarded to Storage, Key Vault, ADF, ADX |
| `tags` | Applied to all resources |
| `location` | Single region deployment |

**Type Import**:
```bicep
import { lockType, diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
```

**Naming Conventions** (per [SNFR22](https://azure.github.io/Azure-Verified-Modules/spec/SNFR22/)):
- All parameters and outputs accepting Azure Resource IDs include `ResourceId` suffix (e.g., `byoBlobDnsZoneResourceId`, `storageAccountResourceId`)
- All outputs returning Resource IDs include `ResourceId` suffix (e.g., `storageAccountResourceId`, `keyVaultResourceId`, `dataFactoryResourceId`)

**Strong Typing** (AVM 1.0 requirement):
- Array parameters use typed arrays where possible (e.g., `adxAdminPrincipalIds string[]` instead of `array`)
- Generic `object` and `array` types avoided except for standard AVM interfaces (`tags`, `tagsByResource`)

**Rationale**:
- Required for AVM module certification
- Consistent experience for AVM consumers
- Enterprise governance requirements (locks, diagnostics)
- SNFR22 naming enables users to identify Resource ID parameters at a glance
- Strong typing catches errors at compile time rather than deployment time

**Consequences**:
- Module depends on `avm/utl/types/avm-common-types:0.6.1`
- All child resources receive lock and diagnostic settings
- README documents all standard parameters
- Parameter/output renames are breaking changes for consumers (acceptable pre-1.0)

---

## ADR-007: ADX Dashboard vs Power BI Strategy

**Date**: February 2026
**Status**: Superseded by ADR-014
**Context**: Determine visualization strategy for FinOps Hub.

**Original Decision**: Include **ADX Dashboard** in AVM module; reference **Power BI reports** from FinOps Toolkit.

**Updated Decision**: All visualization assets (ADX dashboards, Power BI reports) are maintained exclusively in the [FinOps Toolkit](https://aka.ms/finops/toolkit). This AVM module deploys infrastructure only. See **ADR-014** for the full scope separation rationale.

| Visualization | Included In | Maintained By |
|--------------|-------------|---------------|
| ADX Dashboard v13.0 | FinOps Toolkit | FinOps Toolkit |
| Power BI Reports v17 | FinOps Toolkit | FinOps Toolkit |

**Rationale** (updated):
- All visualization and analytics assets belong in the official FinOps Toolkit to avoid duplication
- AVM module scope is limited to Azure infrastructure deployment (see ADR-014)
- Single source of truth for dashboards simplifies versioning and maintenance
- Power BI reports have broader audience (business users)

**When to Use Each**:
| Scenario | Recommendation | Source |
|----------|----------------|--------|
| Central FinOps team | ADX Dashboard | [FinOps Toolkit](https://aka.ms/finops/toolkit) |
| Real-time monitoring | ADX Dashboard | [FinOps Toolkit](https://aka.ms/finops/toolkit) |
| Department distribution with RLS | Power BI | [FinOps Toolkit](https://aka.ms/finops/toolkit/powerbi) |
| Executive presentations | Either | [FinOps Toolkit](https://aka.ms/finops/toolkit) |
| Mobile access | Power BI | [FinOps Toolkit](https://aka.ms/finops/toolkit/powerbi) |

**Consequences**:
- README documents both visualization options with links to FinOps Toolkit
- ADX dashboard available from [FinOps Toolkit](https://aka.ms/finops/toolkit)
- Power BI users directed to aka.ms/finops/toolkit/powerbi
- No visualization files are maintained in this AVM module

---

## ADR-008: Schema Versioning Strategy

**Date**: February 2026
**Status**: Accepted
**Context**: Handle schema evolution and upgrades.

**Decision**: Implement **versioned schema scripts** with **backward compatibility**.

**Schema Versions**:
```
HubSetup_v1_0.kql    → Initial schema
HubSetup_v1_2.kql    → Added MACC support
HubSetup_Latest.kql  → Symlink to current version
```

**Upgrade Path**:
1. Detect current schema version from `HubSettings` table
2. Run incremental migration scripts
3. Update version in settings

**Rationale**:
- Production hubs cannot lose data during upgrades
- Schema changes must be additive (no breaking changes)
- Version detection enables automated upgrades

**Consequences**:
- Each schema version preserved as separate file
- Deployment script checks version before upgrade
- Major version changes documented in CHANGELOG

---

## ADR-009: Adoption of AVM Specification Constraints

**Date**: February 2026
**Status**: Accepted
**Context**: To publish FinOps Hub in the Azure Verified Modules registry, the module must comply with AVM specifications. These specifications impose architectural constraints on module structure, parameter conventions, and artifact generation that differ from the original FinOps Toolkit implementation.

**Decision**: Adopt all AVM specification requirements as binding constraints for this module.

**AVM-Enforced Constraints**:

| Constraint | AVM Requirement | Impact on Module |
|------------|-----------------|------------------|
| Telemetry | `enableTelemetry` parameter must default to `true` | Added parameter, wired to all child modules |
| ARM Template | `main.json` must be committed and match `main.bicep` | Build step required before every commit |
| README | Must be auto-generated via `Set-ModuleReadMe` | Cannot use custom README formatting |
| Line Endings | All files must use LF (Unix-style) | Git config and editor settings enforced |
| Version Format | BRM versioning: `version.json` specifies **major.minor** only (e.g., `"0.12"`); patch is auto-calculated by CI pipeline. `main.bicep` metadata and `CHANGELOG.md` use full semver (e.g., `0.12.0`) | Version must be synchronized across files; `version.json` ≠ three-part semver |
| CHANGELOG | File must be named `CHANGELOG.md` (all caps); links are case-sensitive on Linux CI runners | Case mismatch breaks links in CI |
| Linter Overrides | Module-level `bicepconfig.json` overrides only apply during local development; consumers still see linter warnings unless they also override. Prefer inline `#disable-next-line` where feasible | `modules/bicepconfig.json` retained with comments for rules that have 10+ occurrences across sub-modules |
| Lock Interface | Must support `lockType` from AVM common types | Added lock parameter, applied to all resources |
| Diagnostic Settings | Must support `diagnosticSettingFullType` | Added diagnosticSettings parameter |
| Tags | Must support resource tagging | Added tags and tagsByResource parameters |
| Deployment Scripts | PowerShell scripts must use `#` comments, not `//` | Refactored all inline PowerShell |

**Alternatives Considered**:
| Option | Pros | Cons |
|--------|------|------|
| Publish outside AVM registry | Full control over structure | Less discoverability, no AVM certification |
| Request AVM spec exceptions | Keep existing patterns | Unlikely to be approved, delays publication |
| Full AVM compliance | Registry publication, enterprise trust | Refactoring effort, ongoing maintenance burden |

**Consequences**:
- **Positive**: Module published in official AVM registry with Microsoft support
- **Positive**: Consistent interface with other AVM modules (familiar to AVM users)
- **Positive**: Automatic security and reliability validation via PSRule
- **Negative**: Build workflow required (regenerate main.json, README after changes)
- **Negative**: Less flexibility in documentation formatting
- **Negative**: Contributors must learn AVM conventions

---

## ADR-010: Deployment-Unique Resource Naming for CI Idempotency

**Date**: February 2026
**Status**: Accepted
**Context**: The AVM CI pipeline runs multiple deployment tests in parallel and sequentially. Azure Key Vault enforces a 90-day soft-delete retention period, meaning deleted vaults cannot be purged immediately. When CI runs deploy and tear down resources repeatedly, subsequent runs fail with `VaultAlreadyExists` errors because the Key Vault name is still reserved in the soft-deleted state.

**Decision**: Incorporate a deployment-unique suffix into resource names that are subject to soft-delete or global uniqueness constraints.

**Implementation**:
```bicep
var deploymentSuffix = take(uniqueString(deployment().name), 4)
var keyVaultName = take('kv-${hubName}-${deploymentSuffix}', 24)
```

**Alternatives Considered**:
| Option | Pros | Cons |
|--------|------|------|
| Static naming | Predictable names | CI failures from soft-delete conflicts |
| Purge protection disabled | Allows immediate purge | Not allowed for production workloads |
| Manual purge between runs | Works | Requires CI pipeline changes, adds latency |
| Deployment-unique suffix | Avoids conflicts entirely | Names less predictable |

**Consequences**:
- **Positive**: CI runs are idempotent; parallel test executions don't conflict
- **Positive**: No manual intervention required between CI runs
- **Negative**: Resource names include random suffix, slightly less readable
- **Negative**: Cannot predict exact resource names before deployment

---

## ADR-011: Region Selection Strategy for Capacity-Constrained Resources

**Date**: February 2026
**Status**: Accepted
**Context**: Azure Data Explorer clusters require specific VM SKUs that are not available in all regions. CI deployments frequently failed with `SkuNotAvailable` errors when using default regions like `eastus`, `westeurope`, or `uksouth` due to capacity constraints.

**Decision**: Use `enforcedLocation` parameter in test configurations to target regions with consistent ADX SKU availability, specifically `italynorth` as the primary test region.

**Implementation**:
```bicep
// In test .bicepparam files
param enforcedLocation = 'italynorth'
```

**Alternatives Considered**:
| Option | Pros | Cons |
|--------|------|------|
| Use resource group location | Simple, conventional | Fails when region lacks capacity |
| Retry with fallback regions | Resilient | Complex CI logic, longer run times |
| Dev/Test SKUs only | Always available | Not representative of production |
| Fixed region with known capacity | Reliable, simple | May need updating if capacity changes |

**CI Authentication**:
GitHub OIDC federation token lifetime depends on the identity type:
- **Service Principal**: ~55 minute token lifetime (insufficient for ADX+managed-network ~57 min deployments)
- **Managed Identity (MSI)**: ~24 hour token lifetime (sufficient for all test scenarios)

The CI pipeline uses a User-Assigned Managed Identity (`id-avm-ci-finops-hub`) with OIDC federation to avoid token expiration during long-running ADX deployments.

**Test Scenario Coverage**:
| Scenario | `.e2eignore` | Reason |
|----------|-------------|--------|
| `adx-managed-network` | No | MSI OIDC provides 24h token — sufficient for ~57 min deployment |
| `adx-waf-aligned` | Yes | Log Analytics workspace replication (AZR-000425) cannot provision in CI environment |

**Consequences**:
- **Positive**: CI deployments succeed consistently
- **Positive**: Tests run against production-representative SKUs
- **Positive**: MSI OIDC tokens eliminate timeout issues for long deployments
- **Negative**: Test resources not co-located with CI infrastructure (minor latency)
- **Negative**: Region selection may need periodic review as Azure capacity changes
- **Negative**: `adx-waf-aligned` skips deployment validation due to LAW replication limitations in CI

---

## ADR-012: ADX Principal Assignment Identity Format

**Date**: February 2026
**Status**: Accepted
**Context**: Azure Data Explorer (ADX) cluster principal assignments failed with 401 Unauthorized errors during CI deployments. The deployment script had correct token audience (`https://kusto.kusto.windows.net`) and the managed identity had `AllDatabasesAdmin` role assigned, yet REST API calls to the cluster were rejected.

**Root Cause Discovery**:
ADX `clusterPrincipalAssignments` with `principalType: 'App'` require the **client ID (application ID)**, not the **principal ID (object ID)** of managed identities.

| Identity Property | ARM/RBAC Term | ADX Term | When to Use |
|------------------|---------------|----------|-------------|
| `principalId` | Object ID | Principal ID | Azure RBAC role assignments (`principalType: 'ServicePrincipal'`) |
| `clientId` | Application ID | Application ID | ADX principal assignments (`principalType: 'App'`) |

**The Bug**:
```bicep
// WRONG - Using object ID for ADX App principal
clusterPrincipalAssignments: [
  {
    principalId: managedIdentity.outputs.principalId  // Object ID
    principalType: 'App'  // Expects Application ID!
    role: 'AllDatabasesAdmin'
  }
]
```

**The Fix**:
```bicep
// CORRECT - Using client ID (application ID) for ADX App principal
clusterPrincipalAssignments: [
  {
    principalId: managedIdentity.outputs.clientId  // Application ID
    principalType: 'App'
    role: 'AllDatabasesAdmin'
  }
]
```

**Decision**:
1. Add `effectiveIdentityClientId` variable to track managed identity client ID
2. Use `effectiveIdentityClientId` for ADX `clusterPrincipalAssignments`
3. Continue using `effectiveIdentityPrincipalId` for Azure RBAC role assignments
4. Add `managedIdentityClientId` output for external consumers

**Why This Was Hard to Debug**:
- ARM deployment succeeded (ADX accepted the wrong ID format)
- Principal assignment showed `provisioningState: Succeeded`
- Token acquisition succeeded
- Error only manifested at REST API runtime (401 Unauthorized)
- 30 retries over 13+ minutes all failed with same error
- Different identity formats for different Azure services is non-obvious

**References**:
- [ADX Security Principals](https://learn.microsoft.com/en-us/kusto/management/reference-security-principals): "For App: `aadapp=ApplicationId;TenantId`"
- [ARM clusterPrincipalAssignments](https://learn.microsoft.com/en-us/azure/templates/microsoft.kusto/clusters/principalassignments): "principalId: user email, **application ID**, or security group name"

**Consequences**:
- **Positive**: ADX deployment scripts now authenticate successfully
- **Positive**: Module exposes both `principalId` and `clientId` for flexibility
- **Negative**: None identified

---

### ADR-013: ADF Pipeline for ADX Managed Identity Policy

**Status**: Accepted
**Date**: 2025-02-28
**Context**: ADX native ingestion (`managed_identity = SystemAssigned`) requires a database-level managed identity policy. This policy must be set via the `.alter-merge database policy managed_identity` management command at the cluster/database level. The module needed a reliable way to apply this policy during deployment.

**Platform Limitation**: Azure Data Explorer does not natively support executing cluster-level management commands (such as `.alter-merge cluster policy managed_identity`) through ARM-deployable resources. The `Microsoft.Kusto/clusters/databases/scripts` resource is limited to database-scoped KQL commands. There is no ARM resource type for cluster-level policy management, and deployment scripts that attempt to call the ADX REST API face a known timing gap between the ARM control plane and the Kusto data plane where principal assignments are not yet propagated. This limitation has been reported to the Azure Data Explorer Product Group.

**Problem**: Three approaches were attempted to set the ADX managed identity policy during ARM deployment. The first two failed due to this platform limitation; the third succeeded by deferring execution to runtime.

**Approach 1 — Database Script with `scriptLevel: 'Cluster'`**:
The `Microsoft.Kusto/clusters/databases/scripts` resource supports a `scriptLevel` property. Setting `scriptLevel: 'Cluster'` should elevate the script to run cluster-level management commands. However, this consistently failed with:

```
ScriptFailedUnauthorizedCaller: Caller is not authorized to perform this action
```

While the ARM schema accepts `scriptLevel: 'Cluster'`, ADX documentation states database scripts run in database scope. The `AllDatabasesAdmin` principal assignment had not propagated to the data plane by the time the script executed.

**Approach 2 — Deployment Script via REST API**:
A `Microsoft.Resources/deploymentScripts` resource (`adxManagedIdentityPolicy.bicep`) used the ADX REST API (`/v1/rest/mgmt`) to execute the `.alter-merge` command. This approach required:
- A dedicated storage account with shared key access (AVM private endpoints block public access)
- Azure Container Instances (ACI) for script execution
- A managed identity with `AllDatabasesAdmin` on the ADX cluster

Despite 30+ retry attempts over 13+ minutes, the REST API consistently returned **HTTP 401 Unauthorized**. Root cause: the `clusterPrincipalAssignment` completed on the ARM control plane, but the ADX data plane had not yet propagated the permission. This is a known timing gap between the ARM control plane and the Kusto data plane.

**Approach 3 — ADF Pipeline Activity (Accepted)**:
The managed identity policy is set at runtime via an `AzureDataExplorerCommand` activity ("Set Ingestion Policy") as the first step of the `ingestion_ETL_dataExplorer` pipeline in `dataFactoryResources.bicep`. This approach:
- Uses the ADF managed identity's own principal ID (not the hub MI)
- Applies the policy at **database level** (not cluster level), which is sufficient for ingestion
- Executes the KQL template from `ClusterSetup_ManagedIdentityPolicy.kql`
- Runs through ADF's established ADX linked service connection, which already has authentication configured
- Matches the upstream FinOps toolkit approach exactly

**Why ADF Pipeline Works**:
1. ADF's linked service connection to ADX is established during ADF resource creation, giving sufficient time for permission propagation
2. The policy is applied at first pipeline execution (not during ARM deployment), avoiding the ARM→ADX timing gap entirely
3. Database-level `managed_identity` policy is sufficient — cluster-level is not required for native ingestion
4. ADF's own managed identity is already an `AllDatabasesAdmin`, so the command succeeds without additional permission setup

**Decision**: Set the ADX managed identity policy via the ADF `AzureDataExplorerCommand` pipeline activity at runtime, not during ARM deployment. The legacy deployment script module (`adxManagedIdentityPolicy.bicep`) is retained as reference in case the ADX Product Group addresses the platform limitation in a future API version, but it is **not wired into the orchestration** and is excluded from the deployment graph.

**References**:
- [ADX Managed Identity Policy](https://learn.microsoft.com/en-us/kusto/management/alter-merge-managed-identity-policy-command): `.alter-merge database policy managed_identity`
- [ADX Database Scripts](https://learn.microsoft.com/en-us/azure/data-explorer/database-script): Database-scoped execution
- [ADF ADX Activity](https://learn.microsoft.com/en-us/azure/data-factory/connector-azure-data-explorer): `AzureDataExplorerCommand` activity type
- See `main.bicep` lines 878–885 for inline documentation of this decision

**Consequences**:
- **Positive**: Policy is reliably applied without ARM→ADX timing issues
- **Positive**: No additional infrastructure required (no ACI, no extra storage account)
- **Positive**: Matches upstream FinOps toolkit architecture
- **Positive**: Simpler deployment graph — fewer resources to manage
- **Negative**: Policy is applied at first pipeline run, not during initial deployment (acceptable — ingestion only starts when pipelines run)

---

## ADR-014: Scope Separation — AVM Module vs FinOps Toolkit Repository

**Date**: June 2025
**Status**: Accepted
**Context**: The FinOps Hub AVM module originally included ADX dashboards, KQL query files for dashboard visualizations, and a multi-cloud test data generator script. As the module matured and aligned with AVM conventions (BCPNFR, CI/CD, pattern module constraints), it became clear that maintaining visualization assets, analytics queries, and helper scripts inside the AVM module created duplication and divergence from the official [Microsoft FinOps Toolkit](https://aka.ms/finops/toolkit) repository.

The official FinOps Toolkit (`microsoft/finops-toolkit`) is the canonical source for:
- ADX dashboards and their KQL queries
- Power BI reports
- Test data generators (multi-cloud FOCUS data)
- Helper scripts for analytics and reporting
- KQL functions for FinOps capabilities

Maintaining copies in the AVM module introduced risks: version drift, duplicated maintenance, inconsistent user experience, and increased PR review burden.

**Decision**: This AVM module is scoped exclusively to **Azure infrastructure deployment**. All analytics, reporting, visualization, and helper-script assets are maintained in the [official FinOps Toolkit repository](https://github.com/microsoft/finops-toolkit).

### Scope Boundary

| Concern | Owner | Repository |
|---------|-------|------------|
| Azure Storage Account (ingestion) | **AVM Module** | `Azure/bicep-registry-modules` |
| Azure Data Explorer cluster & database | **AVM Module** | `Azure/bicep-registry-modules` |
| Azure Data Factory pipelines | **AVM Module** | `Azure/bicep-registry-modules` |
| Key Vault & managed identities | **AVM Module** | `Azure/bicep-registry-modules` |
| Network isolation (managed VNet, PEs) | **AVM Module** | `Azure/bicep-registry-modules` |
| KQL functions (ingestion, schema) | **AVM Module** | `Azure/bicep-registry-modules` |
| Deployment helper scripts (Deploy, Get-BestAdxSku, Manage-State) | **AVM Module** | `Azure/bicep-registry-modules` |
| ADX Dashboards | **FinOps Toolkit** | `microsoft/finops-toolkit` |
| Power BI Reports | **FinOps Toolkit** | `microsoft/finops-toolkit` |
| KQL dashboard/analytics queries | **FinOps Toolkit** | `microsoft/finops-toolkit` |
| Multi-cloud test data generators | **FinOps Toolkit** | `microsoft/finops-toolkit` |
| FOCUS use-case query library | **FinOps Toolkit** | `microsoft/finops-toolkit` |

### Options Considered

**Option A — Keep dashboards and scripts in AVM module** (Rejected):
- ✅ Self-contained module (single deployment)
- ❌ Duplicated maintenance across two repositories
- ❌ Version drift between AVM dashboards and official toolkit dashboards
- ❌ Increased PR review surface area for non-infrastructure changes
- ❌ Violates single-source-of-truth principle

**Option B — Infrastructure only in AVM; analytics/reporting in FinOps Toolkit** (Accepted):
- ✅ Single source of truth for each concern
- ✅ Smaller, focused AVM module — easier to review and maintain
- ✅ Dashboard and report updates ship independently via FinOps Toolkit releases
- ✅ Aligns with AVM pattern module conventions (deploy infrastructure, reference external tools)
- ✅ Reduces CI/CD pipeline complexity
- ❌ Users must reference two repositories (mitigated by README links)

**Rationale**:
- AVM modules should focus on deploying and configuring Azure resources
- Visualization and analytics assets have independent release cycles
- The FinOps Toolkit team already maintains the canonical versions of dashboards and reports
- Eliminating duplication reduces maintenance burden and prevents version drift
- README and deployment output provide clear links to FinOps Toolkit assets

**Supersedes**: ADR-007 (ADX Dashboard vs Power BI Strategy)

**References**:
- [FinOps Toolkit Repository](https://github.com/microsoft/finops-toolkit)
- [FinOps Toolkit Portal](https://aka.ms/finops/toolkit)
- [Power BI Reports](https://aka.ms/finops/toolkit/powerbi)
- [AVM Module Specifications](https://azure.github.io/Azure-Verified-Modules/specs/)

**Consequences**:
- **Positive**: Clear ownership boundary — infrastructure in AVM, analytics in FinOps Toolkit
- **Positive**: Smaller module footprint, faster CI/CD validation
- **Positive**: No version drift between dashboard copies
- **Positive**: Users get the latest dashboards directly from the FinOps Toolkit release cycle
- **Negative**: Users must download dashboards separately from FinOps Toolkit (mitigated by README guidance and deployment output links)
- **Negative**: Demo mode no longer includes a pre-built dashboard (mitigated by linking to FinOps Toolkit demo resources)

---

## Related Documentation

For detailed implementation guidance, refer to the official Microsoft Learn documentation:

| Topic | Link |
|-------|------|
| **FinOps Hubs Overview** | [learn.microsoft.com/...finops-hubs-overview](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/finops-hubs-overview) |
| **Deploy FinOps Hub** | [learn.microsoft.com/...deploy-hub](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/deploy-hub) |
| **Configure Exports** | [learn.microsoft.com/...configure-exports](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/configure-exports) |
| **Power BI Reports** | [learn.microsoft.com/...powerbi](https://learn.microsoft.com/cloud-computing/finops/toolkit/powerbi) |
| **FOCUS Specification** | [focus.finops.org](https://focus.finops.org/) |
| **FinOps Framework** | [finops.org/framework](https://www.finops.org/framework/) |
| **Azure Verified Modules** | [aka.ms/avm](https://aka.ms/avm) |

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.5.0 | Mar 2026 | FinOps Toolkit Team | Updated ADR-006 (SNFR22 naming, strong typing), ADR-009 (BRM versioning, linter overrides), ADR-011 (OIDC/MSI); Removed ADR-007 (KQL Functions) and ADR-010 (Experimental Features); Renumbered ADRs sequentially |
| 1.4.0 | Jun 2025 | FinOps Toolkit Team | Added ADR-014 (Scope separation — AVM module vs FinOps Toolkit); Superseded ADR-007 |
| 1.3.0 | Feb 2026 | FinOps Toolkit Team | Added ADR-013 (ADF pipeline for ADX managed identity policy) |
| 1.2.0 | Feb 2026 | FinOps Toolkit Team | Added ADR-012 (ADX principal assignment identity format fix) |
| 1.1.0 | Feb 2026 | FinOps Toolkit Team | Added ADR-009 (AVM constraints), ADR-010 (CI naming), ADR-011 (region selection) |
| 1.0.0 | Feb 2026 | FinOps Toolkit Team | Initial ADRs for AVM module |
