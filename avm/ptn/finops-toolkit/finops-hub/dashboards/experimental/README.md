# Experimental Scripts

This folder contains experimental KQL scripts that are **not auto-deployed** with FinOps Hub. These scripts require manual setup and configuration.

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

### Future Plans

Once MACC data is available in standard exports, these scripts will be integrated into the main deployment.
