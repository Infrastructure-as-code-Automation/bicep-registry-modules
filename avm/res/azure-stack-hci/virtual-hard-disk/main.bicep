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

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  // Add other relevant built-in roles here for your resource as per BCPNFR5
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Azure Stack HCI VM Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '874d1c73-6003-4e60-a13a-cb31ea190a85'
  )
  'Azure Stack HCI VM Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4b3fe76c-f777-4d24-a2d7-b027b0f7b273'
  )
  'Azure Stack HCI Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'bda0d508-adf1-4af0-9c28-88919fc3ae06'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

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

resource virtualHardDisk_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(virtualHardDisk.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: virtualHardDisk
  }
]

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
