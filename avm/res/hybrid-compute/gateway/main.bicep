metadata name = 'Hybrid Compute Gateways'
metadata description = '<Add description>'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the gateway to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Type of gateway to create, the only allowed value is Public.')
param gatewayType 'Public' = 'Public'

@description('Optional. List of features allowed on the gateway. Allowed values are: [\'*\'].')
param allowedFeatures array = ['*']

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.hybridcompute-gateway.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource gateway 'Microsoft.HybridCompute/gateways@2024-11-10-preview' = {
  name: name
  location: location
  properties: {
    allowedFeatures: allowedFeatures
    gatewayType: gatewayType
  }
  tags: tags
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the gateway.')
output name string = gateway.name

@description('The resource ID of the gateway.')
output resourceId string = gateway.id

@description('The name of the resource group the gateway was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the gateway was deployed into.')
output location string = gateway.location

// ================ //
// Definitions      //
// ================ //
