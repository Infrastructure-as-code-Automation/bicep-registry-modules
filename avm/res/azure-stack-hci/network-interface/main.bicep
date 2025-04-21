metadata name = 'Azure Stack HCI Network Interface'
metadata description = 'This module deploys an Azure Stack HCI network interface.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. Resource ID of the associated custom location.')
param customLocationResourceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The properties of the network interface.')
param properties networkInterfacePropertiesType

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
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
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
  name: '46d3xbcp.res.azurestackhci-networkinterface.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource networkInterface 'Microsoft.AzureStackHCI/networkInterfaces@2025-04-01-preview' = {
  name: name
  tags: tags
  extendedLocation: {
    type: 'CustomLocation'
    name: customLocationResourceId
  }
  location: location
  properties: properties
}

resource networkInterface_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(networkInterface.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: networkInterface
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The name of the network interface.')
output name string = networkInterface.name

@description('The resource ID of the network interface.')
output resourceId string = networkInterface.id

@description('The resource group of the network interface.')
output resourceGroupName string = resourceGroup().name

@description('The location of the network interface.')
output location string = networkInterface.location

// ============= //
// Type Definitions //
// ============= //

@export()
@description('The extended location properties.')
type extendedLocationType = {
  @description('Required. The name of the extended location.')
  name: string

  @description('Required. The type of the extended location.')
  type: 'CustomLocation'
}

@export()
@description('The DNS settings for the network interface.')
type interfaceDNSSettingsType = {
  @description('Optional. List of DNS server IP Addresses for the interface.')
  dnsServers: string[]?
}

@export()
@description('The IP configuration properties.')
type ipConfigurationPropertiesType = {
  @description('Optional. Private IP address of the IP configuration.')
  privateIPAddress: string?

  @description('Optional. Name of Subnet bound to the IP configuration.')
  subnet: logicalNetworkArmReferenceType?
}

@export()
@description('The Logical Network ARM reference.')
type logicalNetworkArmReferenceType = {
  @description('Required. The ARM ID for a Logical Network.')
  id: string
}

@export()
@description('The IP configuration properties format.')
type ipConfigurationType = {
  @description('Required. The name of the resource that is unique within a resource group.')
  name: string

  @description('Optional. Properties of IP configuration.')
  properties: ipConfigurationPropertiesType?
}

@export()
@description('The Network Security Group ARM reference.')
type networkSecurityGroupArmReferenceType = {
  @description('Required. The ARM ID for a Network Security Group.')
  id: string
}

@export()
@description('The network interface properties.')
type networkInterfacePropertiesType = {
  @description('Optional. Boolean indicating whether this is a existing local network interface or if one should be created.')
  createFromLocal: bool?

  @description('Optional. DNS Settings for the interface.')
  dnsSettings: interfaceDNSSettingsType?

  @description('Optional. A list of IPConfigurations of the network interface.')
  ipConfigurations: ipConfigurationType[]?

  @description('Optional. The MAC address of the network interface.')
  macAddress: string?

  @description('Optional. Network Security Group attached to the network interface.')
  networkSecurityGroup: networkSecurityGroupArmReferenceType?
}
