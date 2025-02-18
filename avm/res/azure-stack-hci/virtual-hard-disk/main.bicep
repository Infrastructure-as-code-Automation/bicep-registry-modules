metadata name = 'Azure Stack HCI Virtual Hard Disk'
metadata description = 'This module deploys an Azure Stack HCI virtual hard disk.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. Resource ID of the associated custom location.')
param customLocationId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The size of the disk in GB.')
param diskSizeGB int

@description('Required. The disk type.')
param dynamic bool

@description('Optional. The container ID.')
param containerId string?

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.azurestackhci-virtualharddisk.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource virtualHardDisk 'Microsoft.AzureStackHCI/virtualHardDisks@2025-02-01-preview' = {
  name: name
  tags: tags
  extendedLocation: {
    type: 'CustomLocation'
    name: customLocationId
  }
  location: location
  properties: {
    diskSizeGB: diskSizeGB
    dynamic: dynamic
    containerId: containerId
  }
  scope: resourceGroup()
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the virtual hard disk.')
output name string = virtualHardDisk.name

@description('The resource ID of the virtual hard disk.')
output resourceId string = virtualHardDisk.id

@description('The resource group of the virtual hard disk.')
output resourceGroupName string = resourceGroup().name

@description('The location of the virtual hard disk.')
output location string = virtualHardDisk.location
