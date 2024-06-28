@minLength(4)
@maxLength(8)
param deploymentPrefix string
param deploymentUsername string
@secure()
param deploymentUserPassword string
param localAdminUsername string
@secure()
param localAdminPassword string
param arbDeploymentAppId string
param arbDeploymentSPObjectId string
@secure()
param arbDeploymentServicePrincipalSecret string
param location string
param clusterNodeNames array
param softDeleteRetentionDays int = 30
@minValue(0)
@maxValue(365)
param logsRetentionInDays int = 30
param vnetSubnetId string
param serviceShort string = 'ashcmin'
param switchlessStorageConfig bool
param hciNodeCount int
param hciVHDXDownloadURL string
param hciISODownloadURL string
param clusterWitnessStorageAccountName string
param keyVaultDiagnosticStorageAccountName string
param keyVaultName string
param hciResourceProviderObjectId string?
param domainOUPath string?

var arcNodeResourceIds = [
  for (nodeName, index) in clusterNodeNames: resourceId('Microsoft.HybridCompute/machines', nodeName)
]

var tenantId = subscription().tenantId

module arcGateway '../../../arc-gateway/main.bicep' = {
  name: 'arcGateway-${location}-${deploymentPrefix}'
  params: {
    location: location
    name: 'arcg-${location}-${deploymentPrefix}'
    allowedFeatures: ['*']
    gatewayType: 'Public'
  }
}

module hciHostDeployment '../../../../../../utilities/e2e-template-assets/templates/azure-stack-hci/modules/azureStackHCIHost/hciHostDeployment.bicep' = {
  name: 'hciHostDeployment-${location}-${deploymentPrefix}'
  params: {
    arcGatewayId: arcGateway.outputs.resourceId
    domainOUPath: domainOUPath
    deployProxy: true
    hciISODownloadURL: hciISODownloadURL
    hciNodeCount: hciNodeCount
    hciVHDXDownloadURL: hciVHDXDownloadURL
    localAdminPassword: localAdminPassword
    location: location
    switchlessStorageConfig: switchlessStorageConfig
    vnetSubnetID: vnetSubnetId
  }
}

module microsoftGraphResources '../../../../../../utilities/e2e-template-assets/templates/azure-stack-hci/modules/microsoftGraphResources/main.bicep' = if (null == hciResourceProviderObjectId) {
  name: '${uniqueString(deployment().name, location)}-test-arbappreg-${serviceShort}'
  params: {}
}

module hciClusterPreqs '../../../../../../utilities/e2e-template-assets/templates/azure-stack-hci/modules/azureStackHCIClusterPreqs/ashciPrereqs.bicep' = {
  dependsOn: [
    hciHostDeployment
  ]
  name: '${uniqueString(deployment().name, location)}-test-hciclusterreqs-${serviceShort}'
  params: {
    location: location
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    arcNodeResourceIds: arcNodeResourceIds
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    keyVaultDiagnosticStorageAccountName: keyVaultDiagnosticStorageAccountName
    deploymentPrefix: deploymentPrefix
    deploymentUsername: deploymentUsername
    deploymentUserPassword: deploymentUserPassword
    hciResourceProviderObjectId: hciResourceProviderObjectId ?? microsoftGraphResources.outputs.hciRPServicePrincipalId
    keyVaultName: keyVaultName
    localAdminPassword: localAdminPassword
    localAdminUsername: localAdminUsername
    logsRetentionInDays: logsRetentionInDays
    softDeleteRetentionDays: softDeleteRetentionDays
    tenantId: tenantId
    vnetSubnetId: hciHostDeployment.outputs.vnetSubnetId
  }
}
