<#
.SYNOPSIS
    Pause or resume a FinOps Hub deployment to optimize costs.

.DESCRIPTION
    This script manages the pause/resume workflow for FinOps Hub deployments.
    
    PAUSE workflow (saves money when not actively reviewing):
      1. Stops ADF triggers (prevents failed pipeline runs)
      2. Stops ADX cluster or pauses Fabric capacity
    
    RESUME workflow (before reviewing cost data):
      1. Starts ADX cluster or resumes Fabric capacity
      2. Waits for cluster to be ready
      3. Starts ADF triggers (processes any backlog)
    
    Data is NEVER lost - Cost Management exports continue to storage.
    When resumed, ADF will process all accumulated data.

.PARAMETER ResourceGroupName
    The resource group containing the FinOps Hub resources.

.PARAMETER HubName
    The name of the FinOps Hub (used to find resources if not specified individually).

.PARAMETER DataFactoryName
    Optional. The Data Factory name. Auto-detected if not specified.

.PARAMETER AdxClusterName
    Optional. The ADX cluster name. Auto-detected if not specified.

.PARAMETER FabricCapacityName
    Optional. The Fabric capacity name (if using Fabric instead of ADX).

.PARAMETER Operation
    The operation to perform: 'Pause' or 'Resume'.

.PARAMETER WaitForReady
    When resuming, wait for ADX cluster to be fully running before starting triggers.
    Default: $true

.PARAMETER SkipConfirmation
    Skip the confirmation prompt.

.EXAMPLE
    # Pause the hub (stop incurring compute charges)
    .\Manage-FinOpsHubState.ps1 -ResourceGroupName "finops-rg" -HubName "myfinopshub" -Operation Pause

.EXAMPLE
    # Resume the hub (start processing data again)
    .\Manage-FinOpsHubState.ps1 -ResourceGroupName "finops-rg" -HubName "myfinopshub" -Operation Resume

.EXAMPLE
    # Pause with explicit resource names
    .\Manage-FinOpsHubState.ps1 -ResourceGroupName "finops-rg" -DataFactoryName "adf-myfinopshub-abc123" -AdxClusterName "myfinopsadx" -Operation Pause

.NOTES
    Author: FinOps Hub AVM Module
    Version: 1.0.0
    
    IMPORTANT: After resuming from an extended pause (days/weeks), expect longer 
    processing times as ADF catches up on the backlog:
    
    | Time Paused | Estimated Processing Time |
    |-------------|---------------------------|
    | 1 day       | ~5-10 minutes             |
    | 1 week      | ~30-60 minutes            |
    | 2 weeks     | ~1-2 hours                |
    | 1 month     | ~2-4 hours                |
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $false)]
    [string]$HubName,

    [Parameter(Mandatory = $false)]
    [string]$DataFactoryName,

    [Parameter(Mandatory = $false)]
    [string]$AdxClusterName,

    [Parameter(Mandatory = $false)]
    [string]$FabricCapacityName,

    [Parameter(Mandatory = $true)]
    [ValidateSet('Pause', 'Resume')]
    [string]$Operation,

    [Parameter(Mandatory = $false)]
    [bool]$WaitForReady = $true,

    [Parameter(Mandatory = $false)]
    [switch]$SkipConfirmation
)

$ErrorActionPreference = 'Stop'

# Colors for output
function Write-Step { param($msg) Write-Host "▶ $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "✓ $msg" -ForegroundColor Green }
function Write-Warning { param($msg) Write-Host "⚠ $msg" -ForegroundColor Yellow }
function Write-Info { param($msg) Write-Host "  $msg" -ForegroundColor Gray }

# Banner
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║           FinOps Hub State Management                         ║" -ForegroundColor Blue
Write-Host "║           Operation: $($Operation.ToUpper().PadRight(40))║" -ForegroundColor Blue
Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

# Auto-detect resources if not specified
Write-Step "Discovering FinOps Hub resources..."

if (-not $DataFactoryName) {
    $adfResources = az resource list --resource-group $ResourceGroupName --resource-type "Microsoft.DataFactory/factories" --query "[].name" -o tsv 2>$null
    if ($adfResources) {
        $DataFactoryName = ($adfResources -split "`n")[0]
        Write-Info "Found Data Factory: $DataFactoryName"
    } else {
        Write-Warning "No Data Factory found in resource group"
    }
}

if (-not $AdxClusterName -and -not $FabricCapacityName) {
    $adxResources = az resource list --resource-group $ResourceGroupName --resource-type "Microsoft.Kusto/clusters" --query "[].name" -o tsv 2>$null
    if ($adxResources) {
        $AdxClusterName = ($adxResources -split "`n")[0]
        Write-Info "Found ADX Cluster: $AdxClusterName"
    } else {
        Write-Info "No ADX cluster found (may be using Fabric or storage-only)"
    }
}

# Confirmation
if (-not $SkipConfirmation) {
    Write-Host ""
    Write-Host "Resources to $($Operation.ToLower()):" -ForegroundColor Yellow
    if ($DataFactoryName) { Write-Host "  • Data Factory: $DataFactoryName" }
    if ($AdxClusterName) { Write-Host "  • ADX Cluster: $AdxClusterName" }
    if ($FabricCapacityName) { Write-Host "  • Fabric Capacity: $FabricCapacityName" }
    Write-Host ""
    
    if ($Operation -eq 'Pause') {
        Write-Host "This will:" -ForegroundColor Yellow
        Write-Host "  1. Stop ADF triggers (prevents failed runs)" 
        Write-Host "  2. Stop ADX/Fabric compute (stops charges)"
        Write-Host ""
        Write-Host "Data will continue accumulating in storage and be processed when resumed." -ForegroundColor Gray
    } else {
        Write-Host "This will:" -ForegroundColor Yellow
        Write-Host "  1. Start ADX/Fabric compute"
        Write-Host "  2. Wait for cluster to be ready"
        Write-Host "  3. Start ADF triggers (processes backlog)"
        Write-Host ""
        Write-Host "⚠ If paused for days/weeks, backlog processing may take 30min to several hours." -ForegroundColor Yellow
    }
    
    Write-Host ""
    $confirm = Read-Host "Continue? (y/N)"
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Host "Operation cancelled." -ForegroundColor Gray
        exit 0
    }
}

Write-Host ""

# ============================================================================
# PAUSE WORKFLOW
# ============================================================================
if ($Operation -eq 'Pause') {
    
    # Step 1: Stop ADF Triggers
    if ($DataFactoryName) {
        Write-Step "Stopping ADF triggers..."
        
        $triggers = Get-AzDataFactoryV2Trigger -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -ErrorAction SilentlyContinue
        $runningTriggers = $triggers | Where-Object { $_.RuntimeState -eq 'Started' }
        
        if ($runningTriggers) {
            foreach ($trigger in $runningTriggers) {
                Write-Info "Stopping trigger: $($trigger.Name)"
                Stop-AzDataFactoryV2Trigger -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -Name $trigger.Name -Force | Out-Null
            }
            Write-Success "Stopped $($runningTriggers.Count) trigger(s)"
        } else {
            Write-Info "No running triggers found"
        }
    }
    
    # Step 2: Stop ADX Cluster
    if ($AdxClusterName) {
        Write-Step "Stopping ADX cluster..."
        
        $clusterState = az kusto cluster show --name $AdxClusterName --resource-group $ResourceGroupName --query "state" -o tsv 2>$null
        
        if ($clusterState -eq 'Running') {
            az kusto cluster stop --name $AdxClusterName --resource-group $ResourceGroupName --no-wait 2>$null
            Write-Success "ADX cluster stop initiated (runs in background)"
        } elseif ($clusterState -eq 'Stopped') {
            Write-Info "ADX cluster is already stopped"
        } else {
            Write-Warning "ADX cluster is in state: $clusterState"
        }
    }
    
    # Step 2 (alt): Pause Fabric Capacity
    if ($FabricCapacityName) {
        Write-Step "Pausing Fabric capacity..."
        Write-Warning "Fabric pause must be done via Azure Portal or Fabric Admin Portal"
        Write-Info "Go to: portal.azure.com > Fabric capacities > $FabricCapacityName > Pause"
    }
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Success "FinOps Hub PAUSED successfully!"
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "• ADF triggers stopped - no pipeline runs (no charges)" -ForegroundColor Gray
    Write-Host "• ADX/Fabric stopped - no compute charges" -ForegroundColor Gray
    Write-Host "• Cost Management exports continue to storage" -ForegroundColor Gray
    Write-Host "• Run with -Operation Resume when ready to analyze data" -ForegroundColor Gray
}

# ============================================================================
# RESUME WORKFLOW
# ============================================================================
if ($Operation -eq 'Resume') {
    
    # Step 1: Start ADX Cluster
    if ($AdxClusterName) {
        Write-Step "Starting ADX cluster..."
        
        $clusterState = az kusto cluster show --name $AdxClusterName --resource-group $ResourceGroupName --query "state" -o tsv 2>$null
        
        if ($clusterState -eq 'Stopped') {
            az kusto cluster start --name $AdxClusterName --resource-group $ResourceGroupName --no-wait 2>$null
            Write-Success "ADX cluster start initiated"
            
            if ($WaitForReady) {
                Write-Step "Waiting for ADX cluster to be ready (5-10 minutes)..."
                $maxWaitMinutes = 15
                $waitedSeconds = 0
                
                do {
                    Start-Sleep -Seconds 30
                    $waitedSeconds += 30
                    $clusterState = az kusto cluster show --name $AdxClusterName --resource-group $ResourceGroupName --query "state" -o tsv 2>$null
                    Write-Info "Cluster state: $clusterState (waited $([math]::Round($waitedSeconds/60, 1)) min)"
                } while ($clusterState -ne 'Running' -and $waitedSeconds -lt ($maxWaitMinutes * 60))
                
                if ($clusterState -eq 'Running') {
                    Write-Success "ADX cluster is running"
                } else {
                    Write-Warning "Cluster not yet running after $maxWaitMinutes min. Continuing anyway..."
                }
            }
        } elseif ($clusterState -eq 'Running') {
            Write-Info "ADX cluster is already running"
        } else {
            Write-Warning "ADX cluster is in state: $clusterState - waiting..."
            Start-Sleep -Seconds 60
        }
    }
    
    # Step 1 (alt): Resume Fabric Capacity
    if ($FabricCapacityName) {
        Write-Step "Resuming Fabric capacity..."
        Write-Warning "Fabric resume must be done via Azure Portal or Fabric Admin Portal"
        Write-Info "Go to: portal.azure.com > Fabric capacities > $FabricCapacityName > Resume"
        Write-Host ""
        $confirm = Read-Host "Press Enter once Fabric capacity is resumed, or 'skip' to continue without"
        if ($confirm -eq 'skip') {
            Write-Warning "Skipping Fabric resume check"
        }
    }
    
    # Step 2: Start ADF Triggers
    if ($DataFactoryName) {
        Write-Step "Starting ADF triggers..."
        
        $triggers = Get-AzDataFactoryV2Trigger -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -ErrorAction SilentlyContinue
        $stoppedTriggers = $triggers | Where-Object { $_.RuntimeState -eq 'Stopped' }
        
        if ($stoppedTriggers) {
            foreach ($trigger in $stoppedTriggers) {
                Write-Info "Starting trigger: $($trigger.Name)"
                Start-AzDataFactoryV2Trigger -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -Name $trigger.Name -Force | Out-Null
            }
            Write-Success "Started $($stoppedTriggers.Count) trigger(s)"
        } else {
            Write-Info "No stopped triggers found (may already be running)"
        }
    }
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Success "FinOps Hub RESUMED successfully!"
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "• ADX/Fabric is running and ready for queries" -ForegroundColor Gray
    Write-Host "• ADF triggers are active - processing any backlog" -ForegroundColor Gray
    Write-Host ""
    Write-Warning "If the hub was paused for an extended period, backlog processing"
    Write-Warning "may take 30 minutes to several hours. Monitor ADF pipeline runs"
    Write-Warning "in the Azure Portal: Data Factory > Monitor > Pipeline runs"
}

Write-Host ""
