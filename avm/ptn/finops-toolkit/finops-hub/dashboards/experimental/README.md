# Experimental Features

This folder contains experimental KQL scripts and dashboard features that are **not auto-deployed** with FinOps Hub. These features are included in the dashboard under the **EXPERIMENTAL** page group but some require manual setup and configuration.

## Feature Status

| Feature | Dashboard Page | Manual Setup | Description |
|---------|---------------|-------------|-------------|
| **MACC Tracking** | ✅ Included | ⚠️ Required | Track MACC commitment burn-down — requires manual contract data entry |
| **Tag Allocation** | ✅ Included | ❌ None | Analyze cost by resource tags — works with standard FOCUS data |
| **Resource Drilldown** | ✅ Included | ❌ None | Drill into resource-level cost per subscription — works with standard FOCUS data |

---

## MACC (Microsoft Azure Consumption Commitment) Tracking

Track your MACC commitment consumption progress with these scripts.

### Files

| Script | Purpose |
|--------|---------|
| `IngestionSetup_MACC.kql` | Creates raw tables and transform functions for MACC data in the Ingestion database |
| `DashboardQueries_MACC.kql` | Dashboard functions for MACC analysis in the Hub database |
| `ManualEntry_MACC.kql` | Manual entry templates for organizations without API access to MACC data |

### Prerequisites

- FinOps Hub with Azure Data Explorer deployed
- ADX database admin access

### Manual Deployment Steps

1. **Connect to your ADX cluster** using Azure Data Explorer Web UI or Kusto Explorer

2. **Deploy Ingestion tables** (run against `Ingestion` database):
   ```kql
   // Run IngestionSetup_MACC.kql against the Ingestion database
   ```

3. **Deploy Dashboard queries** (run against `Hub` database):
   ```kql
   // Run DashboardQueries_MACC.kql against the Hub database
   ```

4. **For manual entry** (if you don't have API access):
   ```kql
   // Run ManualEntry_MACC.kql against the Hub database
   // Follow the instructions to enter your MACC contract details
   ```

### Data Sources

MACC data can come from:
- **Cost Management API** - Automated ingestion (requires EA/MCA billing)
- **Manual Entry** - For organizations without API access

### Why Experimental?

MACC tracking is experimental because:
- MACC data is not yet available via standard Cost Management exports
- Requires manual API calls or contract data entry
- API formats may change as Microsoft evolves the service

---

## Tag Allocation

Analyze cost allocation using resource tags from FOCUS cost data.

### Dashboard Tiles

| Tile | Visual Type | Description |
|------|-------------|-------------|
| **Tag Coverage** | Multi-stat | Tagged vs untagged cost and resource counts, tag coverage percentage |
| **Cost by tag key** | Bar chart | Top N tag keys by total effective cost |
| **Cost by tag value** | Bar chart | Top N tag key=value pairs by cost |
| **Tag detail** | Table | All tag key-value pairs with cost and resource count (top 50) |
| **Monthly tag coverage trend** | Stacked column | Tagged vs untagged cost over time |

### How It Works

The Tag Allocation queries use the FOCUS `Tags` column, which stores tags as JSON key-value pairs (e.g., `{"env": "prod", "team": "finance"}`). The queries:

1. **Explode tags** using `bag_keys()` and `mv-apply` to create one row per tag key-value pair
2. **Aggregate cost** by tag key and value using `summarize`
3. **Top-N grouping** uses the `maxGroupCount` dashboard parameter

### No Manual Setup Required

Tag Allocation works out of the box with any FinOps Hub deployment that has ADX enabled. It uses the standard `Costs()` function and `Tags` column from FOCUS cost data.

### Known Limitations

- Tags are analyzed as flat key-value pairs — nested or complex tag values are shown as JSON strings
- Tag keys are case-sensitive — `Environment` and `environment` appear as separate keys
- Resources without tags show as "Untagged" in coverage metrics
- The `maxGroupCount` parameter controls how many tag keys/values are shown in charts

---

## Resource Drilldown

Drill into resource-level cost under each subscription.

### Dashboard Tiles

| Tile | Visual Type | Description |
|------|-------------|-------------|
| **Subscription summary** | Multi-stat | Subscription count, resource group count, resource count, total cost |
| **Cost by subscription** | Stacked column | Monthly trend with top-N subscription grouping |
| **Top resources by subscription** | Table | Nested view: Subscription → Resource Group → Resource with cost |
| **Resource cost by service** | Bar chart | Top services by effective cost |
| **Resource cost by resource group** | Bar chart | Top resource groups by effective cost |

### How It Works

The Resource Drilldown queries use FOCUS cost columns to provide a hierarchical view:

```
Subscription → Resource Group → Resource → Service
```

Each level shows effective cost and billed cost, enabling identification of cost drivers at any level of the hierarchy.

### No Manual Setup Required

Resource Drilldown works out of the box with any FinOps Hub deployment that has ADX enabled. It uses standard FOCUS columns: `SubAccountId`, `SubAccountName`, `ResourceId`, `ResourceName`, `x_ResourceGroupName`, `ServiceName`, `x_ResourceType`.

### Known Limitations

- The resource table can be large — results are sorted by subscription then cost (descending)
- The `maxGroupCount` parameter controls top-N grouping in subscription and service charts
- Resources without a subscription (e.g., billing-level charges) are excluded from drilldown

---

## Adding Custom Experimental Features

To add your own experimental dashboard features:

1. **Create KQL queries** in a `.kql` file in this folder
2. **Add tiles** to the dashboard JSON under one of the experimental pages
3. **Follow ADX dashboard schema v67** — all tile IDs must be valid UUIDs
4. **Test locally** by importing the dashboard into your ADX cluster
5. **Document** your feature in this README

### ADX Dashboard JSON Tips

| Rule | Description |
|------|-------------|
| **Valid UUIDs** | All `id` fields must be proper UUIDs (not sequential numbers) |
| **Page references** | Tile `pageId` must match an existing page `id` |
| **Query references** | Tile `queryRef.queryId` must match an existing query `id` |
| **Data source** | Use `dataSourceId: "23540be2-ffc9-4b61-8c4c-05e493e682a6"` for the Hub data source |
| **Base queries** | Use `CostsByMonth`, `CostsByDay`, `CostsPlus` variables for consistent filtering |
| **Layout grid** | Dashboard grid is 22 columns wide, y-position determines vertical order |
| **No `\r\n`** | Query text must use `\n` only — Windows CRLF will cause import failures on Linux |

---

## Future Plans

Once experimental features mature and receive community feedback:
- Tag Allocation and Resource Drilldown may be promoted to the main dashboard pages
- MACC Tracking will be integrated once MACC data is available in standard Cost Management exports
- Additional experimental features (carbon tracking, multi-cloud tags) are planned
