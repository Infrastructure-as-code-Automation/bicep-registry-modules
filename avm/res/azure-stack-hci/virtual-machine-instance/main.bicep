metadata name = 'Azure Stack HCI Virtual Machine Instance'
metadata description = 'This module deploys an Azure Stack HCI Virtual Machine Instance scoped to an Arc machine.'

targetScope = 'resourceGroup'

// ============== //
//   Parameters   //
// ============== //

@description('Optional. The name of the virtual machine instance. Must be "default".')
param name string = 'default'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The name of the Azure Arc machine that will host the virtual machine instance.')
param arcMachineName string

@description('Required. The custom location resource ID.')
param customLocationResourceId string

@description('Optional. Specifies the identity for the virtual machine.')
param identity resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01'>.identity?

@description('Optional. The guest agent install status.')
param guestAgentInstallStatus resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01'>.properties.guestAgentInstallStatus?

@description('Optional. The hardware profile configuration.')
param hardwareProfile resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01'>.properties.hardwareProfile?

@description('Optional. The HTTP proxy configuration.')
param httpProxyConfig resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01'>.properties.httpProxyConfig?

@description('Required. The network profile configuration.')
param networkProfile resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01'>.properties.networkProfile

@description('Optional. The OS profile configuration.')
param osProfile resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01'>.properties.osProfile?

@description('Optional. The resource UID.')
param resourceUid resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01'>.properties.resourceUid?

@description('Optional. The security profile configuration.')
param securityProfile resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01'>.properties.securityProfile?

@description('Required. The storage profile configuration.')
param storageProfile resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01'>.properties.storageProfile

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'Azure Stack HCI VM Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '874d1b80-58a9-4fc3-b604-5c2fe94d5aaa'
  )
  'Azure Stack HCI VM Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4b3fe76c-f777-4d24-a2d7-b027b0f7b273'
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

// ============= //
//   Resources   //
// ============= //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.azurestackhci-virtualmachineinstance.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}',
    64
  )
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

resource arcMachine 'Microsoft.HybridCompute/machines@2024-07-10' existing = {
  name: arcMachineName
}

resource virtualMachineInstance 'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01' = {
  scope: arcMachine
  name: name
  extendedLocation: {
    name: customLocationResourceId
    type: 'CustomLocation'
  }
  identity: identity
  properties: {
    guestAgentInstallStatus: guestAgentInstallStatus
    hardwareProfile: hardwareProfile
    httpProxyConfig: httpProxyConfig
    networkProfile: networkProfile
    osProfile: osProfile
    resourceUid: resourceUid
    securityProfile: securityProfile
    storageProfile: storageProfile
  }
}

resource virtualMachineInstance_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      virtualMachineInstance.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condition is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: virtualMachineInstance
  }
]

// ============ //
//   Outputs    //
// ============ //

@description('The name of the virtual machine instance.')
output name string = virtualMachineInstance.name

@description('The resource ID of the virtual machine instance.')
output resourceId string = virtualMachineInstance.id

@description('The resource group of the virtual machine instance.')
output resourceGroupName string = resourceGroup().name

@description('The location of the virtual machine instance.')
output location string = arcMachine.location

@description('The provisioning state of the virtual machine instance.')
output provisioningState string = virtualMachineInstance.properties.provisioningState

@description('The instance view of the virtual machine instance.')
output instanceView object = virtualMachineInstance.properties.?instanceView ?? {}
