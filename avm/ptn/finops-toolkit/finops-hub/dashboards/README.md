# FinOps Hub Dashboards

This folder contains Azure Data Explorer (ADX) dashboards for visualizing FinOps data ingested by FinOps Hub.

## Overview

**Version**: 13.0 (February 2026)

ADX dashboards provide interactive visualizations for analyzing cloud cost and usage data based on the [FinOps Open Cost and Usage Specification (FOCUS)](https://aka.ms/finops/focus). These dashboards are designed for central FinOps teams and finance stakeholders who need comprehensive visibility into cloud spending.

### What's New in v13.0

| Enhancement | Description |
|-------------|-------------|
| **Page Renames** | "Licensing + SaaS" → "Azure Hybrid Benefit", "Marketplace" → "SaaS" for clarity |
| **SaaS Query Fix** | Fixed `x_PublisherCategory` filter value from `'Vendor'` to `'Marketplace'` (FOCUS schema compliance) |
| **Typo Fixes** | Fixed "Understand uage" → "Understand usage", "aligment" → "alignment" |
| **Improved Descriptions** | Updated headers with clearer explanations for end users |
| **Schema v67 Compliance** | All IDs use valid UUIDs, removed invalid properties |
| **Bug Fixes** | Applied decimal→real type fixes from [#1881](https://github.com/microsoft/finops-toolkit/issues/1881) |
| **Survey Tracking** | Updated to FTK13.0 for telemetry |

> 💎 **Enterprise-Ready**: This dashboard is optimized for executive presentations and leadership reviews with professional styling, interactive cross-filtering, and auto-refresh capabilities.

> ⚠️ **Security Note**: ADX dashboards do not include row-level security (RLS) by default. All users with database reader access can see ALL data in the dashboard. These dashboards are best suited for:
> - Central FinOps teams with full organizational visibility
> - Finance leadership reviewing company-wide spend
> - Cloud Center of Excellence (CCoE) teams
>
> For scenarios requiring data isolation by subscription or business unit, consider Power BI reports with RLS enabled instead.

---

## ✨ Enterprise Features

This dashboard incorporates Azure Data Explorer best practices for executive-grade presentations:

| Feature | Description | Benefit |
|---------|-------------|---------|
| **Auto-Refresh** | 15m default, 5m minimum | Always up-to-date for live presentations |
| **Cross-Filters** | 82 tiles with click-to-filter | Interactive exploration for Q&A sessions |
| **Large KPI Cards** | Multi-stat tiles with large text | Visible from any meeting room position |
| **Optimized Legends** | Right-aligned, visible legends | Clear data series identification |
| **Performance Tuned** | 10 series limit on load, 5-point tooltips | Fast rendering for large datasets |
| **Human-Readable JSON** | 6,000+ lines, properly indented | Easy to version control and customize |

### Visual Types Used

| Visual Type | Count | Use Case |
|-------------|-------|----------|
| Markdown Cards | 64 | Section headers, explanatory text |
| Tables | 40 | Detailed drill-down data |
| Stacked Column | 20 | Time series comparisons |
| Multi-Stat | 15 | Executive KPI summaries |
| Bar/Column | 16 | Category comparisons |
| Pie | 4 | Distribution breakdowns |
| Area/Stacked Area | 5 | Trend visualizations |
| Time Chart | 1 | Time series analysis |

---

## Available Dashboards

### finops-hub-dashboard.json

**Title**: FinOps Hub - Cloud Cost Intelligence Dashboard

**Purpose**: Comprehensive FinOps dashboard aligned with the FinOps Framework capabilities.

**Prerequisites**:
- FinOps Hub deployed with ADX (Azure Data Explorer) enabled
- ADX cluster with cost data ingested
- `Viewer` access to the ADX database (minimum)

---

## Dashboard Pages

The dashboard is organized into sections aligned with the [FinOps Framework](https://www.finops.org/framework/):

### 📊 About
Introduction page with dashboard overview and navigation guidance.

---

### 🔍 UNDERSTAND Domain

#### Summary
- **Purpose**: High-level cost overview and trends
- **Key Visuals**: Monthly cost trends, month-over-month changes, cost by subscription
- **Use Cases**: Quick health check on overall cloud spend

#### Anomaly Management
- **Purpose**: Detect unexpected cost changes and spending patterns
- **Key Visuals**: Daily cost with rolling averages, top cost spikes, deviation analysis
- **Use Cases**: Identify runaway resources, misconfigurations, or unexpected charges
- **FinOps Capability**: [Anomaly Management](http://aka.ms/ftk/fx/anomalies)

#### Data Ingestion
- **Purpose**: Monitor the health of data pipelines and ingestion status
- **Key Visuals**: Ingested months, row counts by dataset, data quality checks
- **Use Cases**: Ensure data freshness, troubleshoot ingestion issues

---

### 💡 OPTIMIZE Domain

#### Rate Optimization
- **Purpose**: Analyze commitment discount utilization and savings opportunities
- **Key Visuals**: 
  - Effective Savings Rate (ESR) calculations
  - Commitment utilization (Reservations, Savings Plans)
  - Savings breakdown by type (negotiated vs commitment)
  - Underutilized commitments
- **Use Cases**: Maximize ROI on commitment discounts, identify waste
- **Key Metrics**:
  - **List Cost**: On-demand pricing without any discounts
  - **Contracted Cost**: After negotiated discounts (EA/MCA pricing)
  - **Effective Cost**: Final cost after all discounts (amortized)
  - **ESR**: Total Savings ÷ List Cost

#### Azure Hybrid Benefit
- **Purpose**: Analyze hybrid benefit licensing for Windows Server, SQL Server, and Linux
- **Key Visuals**: License coverage, underutilized vCPU capacity, eligible resources
- **Use Cases**: Optimize Azure Hybrid Benefit (AHUB) utilization, identify licensing opportunities
- **FinOps Capability**: [Licensing & SaaS](http://aka.ms/ftk/fx/licensing)

#### SaaS
- **Purpose**: Track spending on Azure Marketplace, third-party SaaS, and vendor products
- **Key Visuals**:
  - SaaS summary stats (total spend, publishers, products)
  - Monthly SaaS spend trend
  - Top publishers and products by spend
  - Spend by subscription
- **Use Cases**: Vendor management, SaaS sprawl identification, procurement planning, contract renewals
- **FOCUS Fields**: `PublisherCategory = 'Vendor'`, `PublisherName`, `ServiceName`
- **FinOps Capability**: [Licensing & SaaS](http://aka.ms/ftk/fx/licensing)

#### Spot Analysis
- **Purpose**: Track spot/preemptible instance usage and savings
- **Key Visuals**:
  - Spot summary stats (spend, resources, savings)
  - Pricing category breakdown (On-Demand vs Spot vs Committed)
  - Spot vs On-Demand trend
  - Top spot resources with savings percentage
- **Use Cases**: Identify spot savings opportunities, track spot adoption
- **FOCUS Fields**: `PricingCategory = 'Dynamic'`

---

### 📈 QUANTIFY Domain

#### Budgeting
- **Purpose**: Support budget planning and fiscal accountability
- **Key Visuals**: Monthly spend trends, cost forecasting, budget vs actual
- **Use Cases**: Fiscal year planning, department chargebacks, growth analysis
- **FinOps Capability**: [Budgeting](http://aka.ms/ftk/fx/budgeting)

---

### 🛠️ MANAGE Domain

#### Invoicing + Chargeback
- **Purpose**: Support internal billing and cost allocation processes
- **Key Visuals**: Cost by resource group, subscription, service category
- **Use Cases**: Internal invoicing, showback/chargeback reports, department allocation

---

### 📋 FOCUS (Executive Summary)

- **Purpose**: CFO and Finance team executive summary
- **Key Visuals**:
  - **Executive Summary**: This month cost, last month comparison, 30-day trend
  - **Anomaly Detection**: Daily costs with rolling averages, top spikes
  - **Rate Optimization**: Commitment utilization, savings by type
  - **Multi-Cloud Analysis**: Cost by cloud provider (Azure, AWS, GCP)
  - **Cost Allocation**: Tag coverage, cost by subscription
  - **Budgeting & Forecasting**: Monthly trends, month-over-month changes
- **Use Cases**: Board presentations, finance reviews, executive briefings

---

## How to Import

1. Navigate to your ADX cluster in the Azure portal
2. Select **Dashboards** from the left menu
3. Click **Import dashboard**
4. Select the `finops-hub-dashboard.json` file
5. Update the **data source** connection:
   - Cluster URI: `https://<your-cluster>.kusto.windows.net`
   - Database: `Hub` (default FinOps Hub database name)
6. Click **Save**

---

## Customization

### Dashboard Parameters

The dashboard includes configurable parameters (displayed in the filter bar):

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| `numberOfMonths` | 📅 Monthly trend | 6 | Months shown in monthly trend charts |
| `numberOfDays` | 📊 Daily trend | 28 | Days shown in daily trend charts |
| `maxGroupCount` | 📋 Max groups | 9 | Max groups in charts before "others" bucket |

> 💡 **Tip**: Parameters use icons for visual clarity. Use the filter bar at the top of the dashboard to adjust these values.

### Cross-Filter Interactivity

The dashboard enables **cross-filtering** on 82 tiles, allowing executives to:
1. Click on any chart segment to filter all related visuals
2. Drill into specific subscriptions, services, or time periods
3. Reset filters using the "Reset" button in the top bar

### Adding Custom Pages

1. Open the dashboard in ADX
2. Click **+ Add page**
3. Add tiles using KQL queries against the `Hub` database
4. Key tables available:
   - `Costs` - FOCUS-aligned cost data
   - `Prices` - Price sheet data
   - `Recommendations` - Azure Advisor recommendations
   - `Transactions` - Reservation/savings plan transactions

### Customizing for Your Brand

To customize the dashboard appearance:

1. **Title**: Edit the dashboard title in the settings menu
2. **Color Palette**: Each tile can use different color schemes (blues, greens, categorical)
3. **Conditional Formatting**: Add color rules to highlight thresholds (red/yellow/green)
4. **Legend Position**: Adjust legend placement per tile for optimal readability

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No data visible | Verify data ingestion completed in Data Ingestion page |
| Permission denied | Request `Viewer` role on ADX database |
| Wrong cluster | Update data source connection in dashboard settings |
| Stale data | Check ADF pipeline triggers are running |
| Slow performance | Reduce `numberOfMonths` or `numberOfDays` parameters |
| Too many series | Reduce `maxGroupCount` parameter |

---

## Related Resources

- [FinOps Framework Capabilities](https://www.finops.org/framework/capabilities/)
- [FOCUS Specification](https://focus.finops.org/)
- [Azure Data Explorer Dashboards](https://learn.microsoft.com/azure/data-explorer/azure-data-explorer-dashboards)
- [FinOps Toolkit Documentation](https://aka.ms/finops/toolkit)

---

## FOCUS Compatibility

This dashboard is designed to work with the [FinOps Open Cost and Usage Specification (FOCUS)](https://focus.finops.org/) schema. The table below shows compatibility with different FOCUS versions:

### Version Support Matrix

| FOCUS Version | Release Date | Status | Notes |
|---------------|--------------|--------|-------|
| 1.0-preview(v1) | Nov 2023 | ✅ Fully compatible | Initial preview spec |
| 1.0 | June 2024 | ✅ Fully compatible | **Microsoft exports this version** |
| 1.1 | Nov 2024 | ✅ Compatible | New: `CapacityReservationId`, `CommitmentDiscountQuantity` |
| 1.2 | June 2025 | ✅ Compatible | New: `InvoiceId`, `PricingCurrency`, `SubAccountType` |
| 1.3 | Dec 2025 | ⚠️ Works with deprecations | Deprecated: `ProviderName`, `PublisherName` |

### Column Usage Notes

This dashboard uses the following FOCUS columns that have deprecation notices in v1.3:

| Column | Dashboard Usage | FOCUS 1.3 Replacement | Migration Status |
|--------|----------------|----------------------|------------------|
| `ProviderName` | Commitment discount calculations, FOCUS page provider breakdown | `ServiceProviderName` | Defer until Microsoft exports 1.3 |
| `PublisherName` | SaaS page publisher counts and grouping | *(deprecated, no replacement)* | Defer until Microsoft exports 1.3 |

### Microsoft Extended Columns

The dashboard also uses Microsoft-specific extended columns (prefixed with `x_`):

| Column | Purpose | Stability |
|--------|---------|-----------|
| `x_PublisherCategory` | Filter Marketplace/Vendor vs Microsoft charges | ✅ Stable |
| `x_SkuMeterCategory` | Azure Hybrid Benefit license type detection | ✅ Stable |
| `x_SkuMeterSubcategory` | Azure Hybrid Benefit license type detection | ✅ Stable |

### Forward Compatibility Strategy

1. **Current State**: Microsoft Cost Management exports FOCUS 1.0 schema
2. **Dashboard Approach**: Queries use FOCUS 1.0 columns for maximum compatibility
3. **Future Migration**: When Microsoft upgrades to FOCUS 1.2/1.3:
   - The FinOps Hub `Costs` function abstracts schema changes
   - Dashboard queries will be updated to use new column names
   - Backward compatibility will be maintained where possible

> 💡 **Best Practice**: Monitor the [FOCUS changelog](https://github.com/FinOps-Open-Cost-and-Usage-Spec/FOCUS_Spec/blob/working_draft/CHANGELOG.md) and [Microsoft FOCUS documentation](https://learn.microsoft.com/azure/cost-management-billing/automate/focus-dataset-columns) for schema updates.

---

## Roadmap / TODO

The following dashboard enhancements are planned for future releases:

###  MACC (Microsoft Azure Consumption Commitment)

**Purpose**: Track progress against Microsoft Azure Consumption Commitment (MACC) agreements.

**Status**: ⏳ Requires external data (not in FOCUS/Cost Management exports)

**Planned Visuals**:
- Current MACC agreement details (commitment amount, term, end date)
- Burn-down progress (consumed vs remaining)
- Projected completion date based on current run rate
- Monthly consumption toward MACC
- Days/months remaining in contract
- Risk indicator (on-track, at-risk, over-committed)

**Data Requirements**: 
> ⚠️ MACC agreement details are not available in Cost Management exports. To enable this capability:
> 1. Upload MACC contract data (JSON/CSV) to the FinOps Hub storage account `config` container
> 2. Include: `commitmentAmount`, `startDate`, `endDate`, `contractId`, `eligibleServices`
> 3. Data will be ingested and joined with FOCUS cost data for burn-down calculations
> 4. Note: Only certain Azure services count toward MACC - the config should specify which

**Future Enhancement**: Add a `macc-config.json` schema and ingestion pipeline to FinOps Hub

**Use Cases**: Contract compliance, procurement planning, finance reporting, renewal negotiations

---

## Dashboard Features

### Built-in ADX Best Practices

This dashboard follows Azure Data Explorer dashboard best practices:

| Feature | Value | Description |
|---------|-------|-------------|
| **Auto-Refresh** | Enabled (30m default, 5m min) | Keeps data up-to-date automatically |
| **Base Queries** | 6 reusable queries | Consistent filtering across tiles |
| **Parameters** | 3 configurable filters | User-controlled date ranges and grouping |
| **Cross-Filters** | Enabled on key visuals | Click-to-filter interactivity |
| **Human-Readable JSON** | Formatted with indentation | Easy to version control and diff |

### Batteries Included

All analytics capabilities are built directly into the dashboard:
- ✅ **SaaS tracking** - Full vendor/publisher/marketplace analysis
- ✅ **Spot analysis** - Preemptible instance usage and savings
- ✅ **Anomaly detection** - Rolling averages and spike detection
- ✅ **Rate optimization** - ESR, commitment utilization, savings breakdown
- ✅ **Azure Hybrid Benefit** - License coverage and optimization

No separate query files needed - import the dashboard and everything works immediately.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025 | Initial dashboard aligned with FinOps Hub v1.0.0 |
