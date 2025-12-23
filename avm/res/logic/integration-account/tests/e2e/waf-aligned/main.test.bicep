targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-logic-integration-account-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'liawaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Variables    //
// ============ //

var schemaContent = '''<?xml version="1.0" encoding="utf-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           targetNamespace="http://schemas.contoso.com/purchaseorder"
           xmlns="http://schemas.contoso.com/purchaseorder"
           elementFormDefault="qualified">
  <xs:element name="PurchaseOrder">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="OrderID" type="xs:string"/>
        <xs:element name="OrderDate" type="xs:date"/>
        <xs:element name="CustomerID" type="xs:string"/>
        <xs:element name="TotalAmount" type="xs:decimal"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'''

var mapContent = '''<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:po="http://schemas.contoso.com/purchaseorder">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/po:PurchaseOrder">
    <Order>
      <ID><xsl:value-of select="po:OrderID"/></ID>
      <Date><xsl:value-of select="po:OrderDate"/></Date>
      <Customer><xsl:value-of select="po:CustomerID"/></Customer>
      <Total><xsl:value-of select="po:TotalAmount"/></Total>
    </Order>
  </xsl:template>
</xsl:stylesheet>'''

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      // Operational Excellence: Define trading partners for B2B integration
      partners: [
        {
          name: 'ContosoSupplier'
          b2bPartnerContent: {
            businessIdentities: [
              {
                qualifier: 'ZZ'
                value: 'CONTOSO-SUPPLIER-001'
              }
            ]
          }
          metadata: {
            description: 'Primary supplier partner'
          }
        }
        {
          name: 'FabrikamBuyer'
          b2bPartnerContent: {
            businessIdentities: [
              {
                qualifier: 'ZZ'
                value: 'FABRIKAM-BUYER-001'
              }
            ]
          }
          metadata: {
            description: 'Primary buyer partner'
          }
        }
      ]
      schemas: [
        {
          name: 'PurchaseOrderSchema'
          content: schemaContent
          schemaType: 'Xml'
          metadata: {
            description: 'Purchase order validation schema'
            version: '1.0'
          }
        }
      ]
      // Operational Excellence: Standardized data transformation
      maps: [
        {
          name: 'PurchaseOrderTransform'
          content: mapContent
          mapType: 'Xslt'
          metadata: {
            description: 'Transform purchase order to internal format'
            version: '1.0'
          }
        }
      ]
      // Reliability: Comprehensive diagnostic logging
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: []
          logCategoriesAndGroups: [
            {
              categoryGroup: 'allLogs'
              enabled: true
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
