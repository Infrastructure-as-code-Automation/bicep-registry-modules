targetScope = 'subscription'

metadata name = 'Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration WAF aligned'
metadata description = 'This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster WAF aligned.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azure-stack-hci.cluster-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashcwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

#disable-next-line no-hardcoded-location // Due to quotas and capacity challenges, this region must be used in the AVM testing subscription
var enforcedLocation = 'southeastasia'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

@description('Required. The password of the LCM deployment user and local administrator accounts.')
@secure()
param localAdminPassword string

@description('Required. The location to deploy the resources into.')
param location string

@description('Required. The name of the VM-managed user identity to create, used for HCI Arc onboarding.')
param userAssignedIdentityName string

@description('Required. The name of the maintenance configuration for the Azure Stack HCI Host VM and proxy server.')
param maintenanceConfigurationName string

@description('Required. The name of the Azure VM scale set for the HCI host.')
param HCIHostVirtualMachineScaleSetName string

@description('Conditional. The name of the Network Security Group ro create.')
param networkSecurityGroupName string

@description('Required. The name of the virtual network to create. Used to connect the HCI Azure Host VM to an existing VNET in the same region.')
param virtualNetworkName string

@description('Required. The name of the Network Interface Card to create.')
param networkInterfaceName string

@description('Required. The name prefix for the Disks to create.')
param diskNamePrefix string

@description('Required. The name of the Azure VM to create.')
param virtualMachineName string

@description('Required. The name of the Maintenance Configuration Assignment for the proxy server.')
param maintenanceConfigurationAssignmentName string

@description('Required. The name prefix for the \'wait\' deployment scripts to create.')
param waitDeploymentScriptPrefixName string

var clusterNodeNames = ['hcinode1', 'hcinode2']
module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-hcihostdeploy'
  scope: resourceGroup
  params: {
    hciISODownloadURL: 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
    hciNodeCount: length(clusterNodeNames)
    hostVMSize: 'Standard_E16bds_v5'
    localAdminPassword: localAdminPassword
    location: location
    switchlessStorageConfig: false
    diskNamePrefix: diskNamePrefix
    HCIHostVirtualMachineScaleSetName: HCIHostVirtualMachineScaleSetName
    maintenanceConfigurationAssignmentName: maintenanceConfigurationAssignmentName
    maintenanceConfigurationName: maintenanceConfigurationName
    networkInterfaceName: networkInterfaceName
    networkSecurityGroupName: networkSecurityGroupName
    virtualNetworkName: virtualNetworkName
    userAssignedIdentityName: userAssignedIdentityName
    virtualMachineName: virtualMachineName
    waitDeploymentScriptPrefixName: waitDeploymentScriptPrefixName
  }
}
