// ============================================================================
// FinOps Hub - Type Definitions
// ============================================================================
// Shared type definitions used across all FinOps Hub modules.
// ============================================================================

// FinOps Toolkit version - update when upgrading
@export()
var finOpsToolkitVersion = '0.7.0'

// Container names per FinOps toolkit specification
@export()
var CONFIG = 'config'
@export()
var INGESTION = 'ingestion'
@export()
var MSEXPORTS = 'msexports'

// File separator for ingestion IDs
@export()
var INGESTION_ID_SEPARATOR = '__'

// Data Explorer database names
@export()
var INGESTION_DB = 'Ingestion'
@export()
var HUB_DB = 'Hub'

// ============================================================================
// SCOPE CONFIGURATION TYPES
// ============================================================================

// Scope type for Cost Management exports
// Determines what data can be exported and what permissions are needed
@export()
type scopeTypeEnum = 'ea' | 'mca' | 'subscription' | 'resourceGroup' | 'department' | 'managementGroup'

// Scope configuration for monitoring
// Used to generate settings.json and export guidance
@export()
type scopeConfigType = {
  @description('Required. The Azure resource ID of the scope to monitor (e.g., /providers/Microsoft.Billing/billingAccounts/123456).')
  scopeId: string

  @description('Required. Type of scope - determines export capabilities and required permissions.')
  scopeType: scopeTypeEnum

  @description('Optional. Friendly name for the scope (for documentation purposes).')
  displayName: string?

  @description('Optional. Tenant ID if cross-tenant access is required.')
  tenantId: string?
}

// Export support matrix based on scope type
// Reference: https://learn.microsoft.com/azure/cost-management-billing/costs/tutorial-export-acm-data
@export()
var exportSupportMatrix = {
  ea: {
    supportsFocusCost: true
    supportsPriceSheet: true
    supportsReservationDetails: true
    supportsReservationRecommendations: true
    supportsReservationTransactions: true
    requiredRole: 'Enterprise Administrator or Enrollment Reader'
    notes: 'Full export support. Recommended for enterprise customers.'
  }
  mca: {
    supportsFocusCost: true
    supportsPriceSheet: true
    supportsReservationDetails: true
    supportsReservationRecommendations: true
    supportsReservationTransactions: true
    requiredRole: 'Billing Profile Contributor or Reader'
    notes: 'Full export support. Recommended for MCA customers.'
  }
  subscription: {
    supportsFocusCost: true
    supportsPriceSheet: false
    supportsReservationDetails: false
    supportsReservationRecommendations: false
    supportsReservationTransactions: false
    requiredRole: 'Cost Management Contributor or Reader'
    notes: 'Limited to FOCUS costs only. No pricing or reservation data.'
  }
  resourceGroup: {
    supportsFocusCost: true
    supportsPriceSheet: false
    supportsReservationDetails: false
    supportsReservationRecommendations: false
    supportsReservationTransactions: false
    requiredRole: 'Cost Management Contributor or Reader'
    notes: 'Very limited. Only resource group costs, no pricing data.'
  }
  department: {
    supportsFocusCost: true
    supportsPriceSheet: true
    supportsReservationDetails: true
    supportsReservationRecommendations: false
    supportsReservationTransactions: false
    requiredRole: 'Department Admin or Reader'
    notes: 'EA Department scope. Good for departmental chargeback.'
  }
  managementGroup: {
    supportsFocusCost: true
    supportsPriceSheet: false
    supportsReservationDetails: false
    supportsReservationRecommendations: false
    supportsReservationTransactions: false
    requiredRole: 'Cost Management Contributor or Reader'
    notes: 'Aggregates subscription costs. No pricing data.'
  }
}
