metadata name = 'Azure Stack HCI Virtual Machine Instance'
metadata description = 'This module deploys an Azure Stack HCI virtual machine.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. Resource ID of the associated custom location.')
param customLocation string

@description('Required. Arc Machine resource name.')
param arcMachineResourceName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.azurestackhci-virtualmachineinstance.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource existingMachine 'Microsoft.HybridCompute/machines@2024-07-10' existing = {
  name: arcMachineResourceName
}

resource virtualMachineInstance 'Microsoft.AzureStackHCI/virtualMachineInstances@2024-08-01-preview' = {
  name: name
  tags: tags
  extendedLocation: {
    type: 'CustomLocation'
    name: customLocation
  }
  properties: {
    // Add your properties here
  }
  scope: existingMachine
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the virtual machine instance.')
output name string = virtualMachineInstance.name

@description('The resource ID of the virtual machine instance.')
output resourceId string = virtualMachineInstance.id

@description('The resource group of the virtual machine instance.')
output resourceGroupName string = resourceGroup().name
