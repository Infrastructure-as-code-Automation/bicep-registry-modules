param location string

param clusterWitnessStorageAccountName string
param keyVaultDiagnosticStorageAccountName string
param keyVaultName string
param softDeleteRetentionDays int = 30
param logsRetentionInDays int = 30
param tenantId string
@secure()
param hciResourceProviderObjectId string?
param arcNodeResourceIds array
param deploymentUsername string
@secure()
param deploymentUserPassword string
param localAdminUsername string
@secure()
param localAdminPassword string
@secure()
param arbDeploymentAppId string
@secure()
param arbDeploymentSPObjectId string
@secure()
param arbDeploymentServicePrincipalSecret string
param vnetSubnetId string?
param allowIPtoStorageAndKeyVault string?

// secret names for the Azure Key Vault - these cannot be changed
var localAdminSecretName = 'LocalAdminCredential'
var domainAdminSecretName = 'AzureStackLCMUserCredential'
var arbDeploymentServicePrincipalName = 'DefaultARBApplication'
var storageWitnessName = 'WitnessStorageKey'

// create base64 encoded secret values to be stored in the Azure Key Vault
var deploymentUserSecretValue = base64('${deploymentUsername}:${deploymentUserPassword}')
var localAdminSecretValue = base64('${localAdminUsername}:${localAdminPassword}')
var arbDeploymentServicePrincipalValue = base64('${arbDeploymentAppId}:${arbDeploymentServicePrincipalSecret}')

var storageAccountType = 'Standard_ZRS'

var azureConnectedMachineResourceManagerRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'f5819b54-e033-4d82-ac66-4fec3cbf3f4c'
)
var readerRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
)
var azureStackHCIDeviceManagementRole = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '865ae368-6a45-4bd1-8fbf-0d5151f56fc1'
)
var keyVaultSecretUserRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '4633458b-17de-408a-b874-0445c86b69e6'
)

module ARBDeploymentSPNSubscriptionRoleAssignmnent 'ashciARBSPRoleAssignment.bicep' = {
  scope: subscription()
  name: '${uniqueString(deployment().name, location)}-test-arbroleassignment'
  params: {
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
  }
}

resource diagnosticStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: toLower(keyVaultDiagnosticStorageAccountName)
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
  }
  resource blobService 'blobServices' = {
    name: 'default'
    properties: {
      deleteRetentionPolicy: {
        enabled: true
        days: 7
      }
      containerDeleteRetentionPolicy: {
        enabled: true
        days: 7
      }
    }
  }
}

resource witnessStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: clusterWitnessStorageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: (allowIPtoStorageAndKeyVault != null)
        ? [
            {
              value: allowIPtoStorageAndKeyVault
            }
          ]
        : []
      virtualNetworkRules: (vnetSubnetId != null)
        ? [
            {
              id: vnetSubnetId
            }
          ]
        : []
    }
  }
  resource blobService 'blobServices' = {
    name: 'default'
    properties: {
      deleteRetentionPolicy: {
        enabled: true
        days: 7
      }
      containerDeleteRetentionPolicy: {
        enabled: true
        days: 7
      }
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionDays
    enableRbacAuthorization: true
    publicNetworkAccess: 'Enabled'
    accessPolicies: []
    tenantId: tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: (allowIPtoStorageAndKeyVault != null)
        ? [
            {
              value: allowIPtoStorageAndKeyVault
            }
          ]
        : []
      virtualNetworkRules: (vnetSubnetId != null)
        ? [
            {
              id: vnetSubnetId
            }
          ]
        : []
    }
  }
  dependsOn: [
    diagnosticStorageAccount
  ]
}

resource keyVaultName_Microsoft_Insights_service 'microsoft.insights/diagnosticSettings@2016-09-01' = {
  name: 'service'
  location: location
  scope: keyVault
  properties: {
    storageAccountId: diagnosticStorageAccount.id
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: logsRetentionInDays
        }
      }
    ]
  }
}

resource SPConnectedMachineResourceManagerRolePermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('ConnectedMachineResourceManagerRolePermissions', resourceGroup().id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: azureConnectedMachineResourceManagerRoleID
    principalId: hciResourceProviderObjectId
    principalType: 'ServicePrincipal'
    description: 'Created by Azure Stack HCI deployment template'
  }
}

resource NodeAzureConnectedMachineResourceManagerRolePermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(resourceGroup().id, hciNode, azureConnectedMachineResourceManagerRoleID)
    properties: {
      roleDefinitionId: azureConnectedMachineResourceManagerRoleID
      principalId: reference(hciNode, '2023-10-03-preview', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]
resource NodeazureStackHCIDeviceManagementRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(resourceGroup().id, hciNode, azureStackHCIDeviceManagementRole)
    properties: {
      roleDefinitionId: azureStackHCIDeviceManagementRole
      principalId: reference(hciNode, '2023-10-03-preview', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

resource NodereaderRoleIDPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(resourceGroup().id, hciNode, readerRoleID)
    properties: {
      roleDefinitionId: readerRoleID
      principalId: reference(hciNode, '2023-10-03-preview', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

resource KeyVaultSecretsUserPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(resourceGroup().id, hciNode, keyVaultSecretUserRoleID)
    scope: keyVault
    properties: {
      roleDefinitionId: keyVaultSecretUserRoleID
      principalId: reference(hciNode, '2023-10-03-preview', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

resource keyVaultName_domainAdminSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: domainAdminSecretName
  properties: {
    contentType: 'Secret'
    value: deploymentUserSecretValue
    attributes: {
      enabled: true
    }
  }
}

resource keyVaultName_localAdminSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: localAdminSecretName
  properties: {
    contentType: 'Secret'
    value: localAdminSecretValue
    attributes: {
      enabled: true
    }
  }
}

resource keyVaultName_arbDeploymentServicePrincipal 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: arbDeploymentServicePrincipalName
  properties: {
    contentType: 'Secret'
    value: arbDeploymentServicePrincipalValue
    attributes: {
      enabled: true
    }
  }
}

resource keyVaultName_storageWitness 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: storageWitnessName
  properties: {
    contentType: 'Secret'
    value: base64(witnessStorageAccount.listKeys().keys[0].value)
    attributes: {
      enabled: true
    }
  }
}
