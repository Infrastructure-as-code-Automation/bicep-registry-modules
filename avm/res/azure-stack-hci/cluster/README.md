# Azure Stack HCI Cluster `[Microsoft.AzureStackHCI/clusters]`

This module deploys an Azure Stack HCI Cluster on the provided Arc Machines.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2020-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments) |
| `Microsoft.AzureStackHCI/clusters` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/clusters) |
| `Microsoft.Compute/disks` | [2023-10-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2023-10-02/disks) |
| `Microsoft.Compute/virtualMachines` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/runCommands` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-01/virtualMachines/runCommands) |
| `Microsoft.Compute/virtualMachineScaleSets` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-01/virtualMachineScaleSets) |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments) |
| `Microsoft.Maintenance/maintenanceConfigurations` | [2023-09-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-09-01-preview/maintenanceConfigurations) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-07-31-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-07-31-preview/userAssignedIdentities) |
| `Microsoft.Network/networkInterfaces` | [2020-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-11-01/networkInterfaces) |
| `Microsoft.Network/networkSecurityGroups` | [2020-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-11-01/networkSecurityGroups) |
| `Microsoft.Network/virtualNetworks` | [2020-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-11-01/virtualNetworks) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/cluster:<version>`.

- [Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration](#example-1-deploy-azure-stack-hci-cluster-in-azure-with-a-2-node-switched-configuration)
- [Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration WAF aligned](#example-2-deploy-azure-stack-hci-cluster-in-azure-with-a-2-node-switched-configuration-waf-aligned)

### Example 1: _Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration_

This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/azure-stack-hci/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    diskNamePrefix: '<diskNamePrefix>'
    HCIHostVirtualMachineScaleSetName: '<HCIHostVirtualMachineScaleSetName>'
    localAdminPassword: '<localAdminPassword>'
    location: '<location>'
    maintenanceConfigurationAssignmentName: '<maintenanceConfigurationAssignmentName>'
    maintenanceConfigurationName: '<maintenanceConfigurationName>'
    networkInterfaceName: '<networkInterfaceName>'
    networkSecurityGroupName: '<networkSecurityGroupName>'
    userAssignedIdentityName: '<userAssignedIdentityName>'
    virtualMachineName: '<virtualMachineName>'
    virtualNetworkName: '<virtualNetworkName>'
    waitDeploymentScriptPrefixName: '<waitDeploymentScriptPrefixName>'
    // Non-required parameters
    hciISODownloadURL: 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
    hciNodeCount: '<hciNodeCount>'
    hostVMSize: 'Standard_E16bds_v5'
    switchlessStorageConfig: false
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "diskNamePrefix": {
      "value": "<diskNamePrefix>"
    },
    "HCIHostVirtualMachineScaleSetName": {
      "value": "<HCIHostVirtualMachineScaleSetName>"
    },
    "localAdminPassword": {
      "value": "<localAdminPassword>"
    },
    "location": {
      "value": "<location>"
    },
    "maintenanceConfigurationAssignmentName": {
      "value": "<maintenanceConfigurationAssignmentName>"
    },
    "maintenanceConfigurationName": {
      "value": "<maintenanceConfigurationName>"
    },
    "networkInterfaceName": {
      "value": "<networkInterfaceName>"
    },
    "networkSecurityGroupName": {
      "value": "<networkSecurityGroupName>"
    },
    "userAssignedIdentityName": {
      "value": "<userAssignedIdentityName>"
    },
    "virtualMachineName": {
      "value": "<virtualMachineName>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "waitDeploymentScriptPrefixName": {
      "value": "<waitDeploymentScriptPrefixName>"
    },
    // Non-required parameters
    "hciISODownloadURL": {
      "value": "https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso"
    },
    "hciNodeCount": {
      "value": "<hciNodeCount>"
    },
    "hostVMSize": {
      "value": "Standard_E16bds_v5"
    },
    "switchlessStorageConfig": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/cluster:<version>'

// Required parameters
param diskNamePrefix = '<diskNamePrefix>'
param HCIHostVirtualMachineScaleSetName = '<HCIHostVirtualMachineScaleSetName>'
param localAdminPassword = '<localAdminPassword>'
param location = '<location>'
param maintenanceConfigurationAssignmentName = '<maintenanceConfigurationAssignmentName>'
param maintenanceConfigurationName = '<maintenanceConfigurationName>'
param networkInterfaceName = '<networkInterfaceName>'
param networkSecurityGroupName = '<networkSecurityGroupName>'
param userAssignedIdentityName = '<userAssignedIdentityName>'
param virtualMachineName = '<virtualMachineName>'
param virtualNetworkName = '<virtualNetworkName>'
param waitDeploymentScriptPrefixName = '<waitDeploymentScriptPrefixName>'
// Non-required parameters
param hciISODownloadURL = 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
param hciNodeCount = '<hciNodeCount>'
param hostVMSize = 'Standard_E16bds_v5'
param switchlessStorageConfig = false
```

</details>
<p>

### Example 2: _Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration WAF aligned_

This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster WAF aligned.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/azure-stack-hci/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    diskNamePrefix: '<diskNamePrefix>'
    HCIHostVirtualMachineScaleSetName: '<HCIHostVirtualMachineScaleSetName>'
    localAdminPassword: '<localAdminPassword>'
    location: '<location>'
    maintenanceConfigurationAssignmentName: '<maintenanceConfigurationAssignmentName>'
    maintenanceConfigurationName: '<maintenanceConfigurationName>'
    networkInterfaceName: '<networkInterfaceName>'
    networkSecurityGroupName: '<networkSecurityGroupName>'
    userAssignedIdentityName: '<userAssignedIdentityName>'
    virtualMachineName: '<virtualMachineName>'
    virtualNetworkName: '<virtualNetworkName>'
    waitDeploymentScriptPrefixName: '<waitDeploymentScriptPrefixName>'
    // Non-required parameters
    hciISODownloadURL: 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
    hciNodeCount: '<hciNodeCount>'
    hostVMSize: 'Standard_E16bds_v5'
    switchlessStorageConfig: false
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "diskNamePrefix": {
      "value": "<diskNamePrefix>"
    },
    "HCIHostVirtualMachineScaleSetName": {
      "value": "<HCIHostVirtualMachineScaleSetName>"
    },
    "localAdminPassword": {
      "value": "<localAdminPassword>"
    },
    "location": {
      "value": "<location>"
    },
    "maintenanceConfigurationAssignmentName": {
      "value": "<maintenanceConfigurationAssignmentName>"
    },
    "maintenanceConfigurationName": {
      "value": "<maintenanceConfigurationName>"
    },
    "networkInterfaceName": {
      "value": "<networkInterfaceName>"
    },
    "networkSecurityGroupName": {
      "value": "<networkSecurityGroupName>"
    },
    "userAssignedIdentityName": {
      "value": "<userAssignedIdentityName>"
    },
    "virtualMachineName": {
      "value": "<virtualMachineName>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "waitDeploymentScriptPrefixName": {
      "value": "<waitDeploymentScriptPrefixName>"
    },
    // Non-required parameters
    "hciISODownloadURL": {
      "value": "https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso"
    },
    "hciNodeCount": {
      "value": "<hciNodeCount>"
    },
    "hostVMSize": {
      "value": "Standard_E16bds_v5"
    },
    "switchlessStorageConfig": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/cluster:<version>'

// Required parameters
param diskNamePrefix = '<diskNamePrefix>'
param HCIHostVirtualMachineScaleSetName = '<HCIHostVirtualMachineScaleSetName>'
param localAdminPassword = '<localAdminPassword>'
param location = '<location>'
param maintenanceConfigurationAssignmentName = '<maintenanceConfigurationAssignmentName>'
param maintenanceConfigurationName = '<maintenanceConfigurationName>'
param networkInterfaceName = '<networkInterfaceName>'
param networkSecurityGroupName = '<networkSecurityGroupName>'
param userAssignedIdentityName = '<userAssignedIdentityName>'
param virtualMachineName = '<virtualMachineName>'
param virtualNetworkName = '<virtualNetworkName>'
param waitDeploymentScriptPrefixName = '<waitDeploymentScriptPrefixName>'
// Non-required parameters
param hciISODownloadURL = 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
param hciNodeCount = '<hciNodeCount>'
param hostVMSize = 'Standard_E16bds_v5'
param switchlessStorageConfig = false
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diskNamePrefix`](#parameter-disknameprefix) | string | The name prefix for the Disks to create. |
| [`HCIHostVirtualMachineScaleSetName`](#parameter-hcihostvirtualmachinescalesetname) | string | The name of the Azure VM scale set for the HCI host. |
| [`localAdminPassword`](#parameter-localadminpassword) | securestring | The local admin password. |
| [`location`](#parameter-location) | string | The location for all resource except HCI Arc Nodes and HCI resources |
| [`maintenanceConfigurationAssignmentName`](#parameter-maintenanceconfigurationassignmentname) | string | The name of the Maintenance Configuration Assignment for the proxy server. |
| [`maintenanceConfigurationName`](#parameter-maintenanceconfigurationname) | string | The name of the maintenance configuration for the Azure Stack HCI Host VM and proxy server. |
| [`networkInterfaceName`](#parameter-networkinterfacename) | string | The name of the Network Interface Card to create. |
| [`networkSecurityGroupName`](#parameter-networksecuritygroupname) | string | The name of the NSG to create. |
| [`userAssignedIdentityName`](#parameter-userassignedidentityname) | string | The name of the VM-managed user identity to create, used for HCI Arc onboarding. |
| [`virtualMachineName`](#parameter-virtualmachinename) | string | The name of the Azure VM to create. |
| [`virtualNetworkName`](#parameter-virtualnetworkname) | string | The name of the VNET for the HCI host Azure VM. |
| [`waitDeploymentScriptPrefixName`](#parameter-waitdeploymentscriptprefixname) | string | The name prefix for the 'wait' deployment scripts to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hciISODownloadURL`](#parameter-hciisodownloadurl) | string | The download URL for the Azure Stack HCI ISO. |
| [`hciNodeCount`](#parameter-hcinodecount) | int | The number of Azure Stack HCI nodes to deploy. |
| [`hostVMSize`](#parameter-hostvmsize) | string | The Azure VM size for the HCI Host VM, which must support nested virtualization and have sufficient capacity for the HCI node VMs! |
| [`localAdminUsername`](#parameter-localadminusername) | string | The local admin user name. |
| [`switchlessStorageConfig`](#parameter-switchlessstorageconfig) | bool | Enable configuring switchless storage. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `diskNamePrefix`

The name prefix for the Disks to create.

- Required: Yes
- Type: string

### Parameter: `HCIHostVirtualMachineScaleSetName`

The name of the Azure VM scale set for the HCI host.

- Required: Yes
- Type: string

### Parameter: `localAdminPassword`

The local admin password.

- Required: Yes
- Type: securestring

### Parameter: `location`

The location for all resource except HCI Arc Nodes and HCI resources

- Required: Yes
- Type: string

### Parameter: `maintenanceConfigurationAssignmentName`

The name of the Maintenance Configuration Assignment for the proxy server.

- Required: Yes
- Type: string

### Parameter: `maintenanceConfigurationName`

The name of the maintenance configuration for the Azure Stack HCI Host VM and proxy server.

- Required: Yes
- Type: string

### Parameter: `networkInterfaceName`

The name of the Network Interface Card to create.

- Required: Yes
- Type: string

### Parameter: `networkSecurityGroupName`

The name of the NSG to create.

- Required: Yes
- Type: string

### Parameter: `userAssignedIdentityName`

The name of the VM-managed user identity to create, used for HCI Arc onboarding.

- Required: Yes
- Type: string

### Parameter: `virtualMachineName`

The name of the Azure VM to create.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkName`

The name of the VNET for the HCI host Azure VM.

- Required: Yes
- Type: string

### Parameter: `waitDeploymentScriptPrefixName`

The name prefix for the 'wait' deployment scripts to create.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hciISODownloadURL`

The download URL for the Azure Stack HCI ISO.

- Required: No
- Type: string
- Default: `'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'`

### Parameter: `hciNodeCount`

The number of Azure Stack HCI nodes to deploy.

- Required: No
- Type: int
- Default: `2`

### Parameter: `hostVMSize`

The Azure VM size for the HCI Host VM, which must support nested virtualization and have sufficient capacity for the HCI node VMs!

- Required: No
- Type: string
- Default: `'Standard_E32bds_v5'`

### Parameter: `localAdminUsername`

The local admin user name.

- Required: No
- Type: string
- Default: `'admin-hci'`

### Parameter: `switchlessStorageConfig`

Enable configuring switchless storage.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the vm. |
| `name` | string | The name of the vm. |
| `resourceGroupName` | string | The resource group of the vm. |
| `resourceId` | string | The resource ID of the vm. |
| `vnetSubnetResourceId` | string | The id of the vnet subnet. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
