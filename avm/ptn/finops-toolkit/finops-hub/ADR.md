# Architecture Decision Records (ADR)

This document captures the key architecture and design decisions made for the FinOps Hub AVM module.

> **📚 Documentation**: For comprehensive FinOps Hub documentation, see [Microsoft Learn - FinOps Hubs](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/finops-hubs-overview).

---

## Engineering Summary

This module represents the culmination of feedback from enterprise customers deploying FinOps solutions at scale. Key engineering principles:

| Principle | Implementation |
|-----------|----------------|
| **Separation of concerns** | Storage (ingestion) → ADX/Fabric (analytics) → Power BI (visualization) |
| **Multi-cloud from day one** | FOCUS schema enables Azure, AWS, GCP, OCI in single data model |
| **Enterprise-ready defaults** | WAF-aligned mode, managed identities, network isolation options |
| **Accessible for all** | Demo mode for PAYGO tenants, test data generators for POCs |

### Customer Feedback Incorporated

- **"We need to start small and scale"** → Storage-only mode, Dev/Test ADX SKUs
- **"Security team requires private endpoints"** → Managed VNet option with automatic PE provisioning  
- **"We have data from multiple clouds"** → Multi-cloud test data generator, FOCUS normalization
- **"FinOps team needs real-time data"** → ADX with 5-15 minute auto-refresh dashboards
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

**Rationale**:
- Required for AVM module certification
- Consistent experience for AVM consumers
- Enterprise governance requirements (locks, diagnostics)

**Consequences**:
- Module depends on `avm/utl/types/avm-common-types:0.6.1`
- All child resources receive lock and diagnostic settings
- README documents all standard parameters

---

## ADR-007: KQL Function Architecture

**Date**: February 2026  
**Status**: Accepted  
**Context**: Organize KQL functions for maintainability and usability.

**Decision**: Use **materialized functions** with **folder organization** following FOCUS use cases.

**Folder Structure**:
```
Dashboard/
├── AnomalyManagement/
├── RateOptimization/
├── MultiCloud/
├── Allocation/
├── Budgeting/
└── Executive/
```

**Function Categories**:
| Category | Functions | Purpose |
|----------|-----------|---------|
| FOCUS Use Cases | 15 | Official FOCUS use case implementations |
| Advanced Analytics | 12 | Forecasting, optimization, anomaly detection |
| Dashboard Helpers | 8 | Visualization-specific transformations |

**Rationale**:
- FOCUS use cases provide industry-standard queries
- Folder organization mirrors FinOps Framework domains
- Functions are reusable across dashboards and Power BI

**Consequences**:
- Functions deployed via ADX schema setup script
- Dashboard references functions (not inline KQL)
- Upgrading schema updates all functions

---

## ADR-008: ADX Dashboard vs Power BI Strategy

**Date**: February 2026  
**Status**: Accepted  
**Context**: Determine visualization strategy for FinOps Hub.

**Decision**: Include **ADX Dashboard** in AVM module; reference **Power BI reports** from FinOps Toolkit.

| Visualization | Included In | Maintained By |
|--------------|-------------|---------------|
| ADX Dashboard v13.0 | AVM Module | AVM Module |
| Power BI Reports v17 | FinOps Toolkit | FinOps Toolkit |

**Rationale**:
- ADX dashboards are JSON files (easy to include in module)
- Power BI reports are complex (.pbix) with separate release cycle
- Avoid duplication of maintenance effort
- Power BI reports have broader audience (business users)

**When to Use Each**:
| Scenario | Recommendation |
|----------|----------------|
| Central FinOps team | ADX Dashboard |
| Real-time monitoring | ADX Dashboard |
| Department distribution with RLS | Power BI |
| Executive presentations | Either |
| Mobile access | Power BI |

**Consequences**:
- README documents both options
- ADX dashboard included in `dashboards/` folder
- Power BI users directed to aka.ms/finops/toolkit/powerbi

---

## ADR-009: Schema Versioning Strategy

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

## ADR-010: Experimental Features Isolation

**Date**: February 2026  
**Status**: Accepted  
**Context**: Handle features that are not yet production-ready.

**Decision**: Isolate experimental features in `modules/scripts/experimental/` folder.

**Current Experimental Features**:
| Feature | Status | Files |
|---------|--------|-------|
| MACC Tracking | Experimental | `*_MACC.kql` |

**Rationale**:
- MACC (Microsoft Azure Consumption Commitment) queries are complex
- Requires billing account access not all customers have
- Needs more testing before general availability

**Inclusion Criteria**:
- Feature works but needs broader validation
- May have edge cases not yet handled
- Documentation incomplete

**Graduation Criteria**:
- 3+ production customers validated
- Edge cases documented
- Full test coverage

**Consequences**:
- Experimental scripts not deployed by default
- README notes experimental status
- Clear path to promote to production

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
| 1.0.0 | Feb 2026 | FinOps Toolkit Team | Initial ADRs for AVM module |
