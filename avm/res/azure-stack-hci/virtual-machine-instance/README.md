# Azure Stack HCI Virtual Machine Instance `[Microsoft.AzureStackHCI/virtualMachineInstances]`

This module deploys an Azure Stack HCI virtual machine.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AzureStackHCI/virtualMachineInstances` | [2024-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/2024-08-01-preview/virtualMachineInstances) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>`.

- [Defaults](#example-1-defaults)
- [Waf-Aligned](#example-2-waf-aligned)

### Example 1: _Defaults_

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineInstance 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>' = {
  name: 'virtualMachineInstanceDeployment'
  params: {
    // Required parameters
    arcMachineResourceName: ''
    customLocation: '<customLocation>'
    name: 'ashvmiminvhd'
    location: '<location>'
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
    "arcMachineResourceName": {
      "value": ""
    },
    "customLocation": {
      "value": "<customLocation>"
    },
    "name": {
      "value": "ashvmiminvhd"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>'

// Required parameters
param arcMachineResourceName = ''
param customLocation = '<customLocation>'
param name = 'ashvmiminvhd'
param location = '<location>'
```

</details>
<p>

### Example 2: _Waf-Aligned_

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineInstance 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>' = {
  name: 'virtualMachineInstanceDeployment'
  params: {
    // Required parameters
    arcMachineResourceName: '<arcMachineResourceName>'
    customLocation: '<customLocation>'
    name: 'ashvmiwafvhd'
    location: '<location>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
    "arcMachineResourceName": {
      "value": "<arcMachineResourceName>"
    },
    "customLocation": {
      "value": "<customLocation>"
    },
    "name": {
      "value": "ashvmiwafvhd"
    },
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>'

// Required parameters
param arcMachineResourceName = '<arcMachineResourceName>'
param customLocation = '<customLocation>'
param name = 'ashvmiwafvhd'
param location = '<location>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`arcMachineResourceName`](#parameter-arcmachineresourcename) | string | Existing Arc Machine resource name. |
| [`customLocation`](#parameter-customlocation) | string | Resource ID of the associated custom location. |
| [`name`](#parameter-name) | string | Name of the virtual machine instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

**Hardware profile configuration parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |

**HTTP proxy configuration parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |

**Network profile configuration parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |

**OS profile configuration parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |

**Security profile configuration parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |

**Storage profile configuration parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |

**Resource UID parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |

### Parameter: `arcMachineResourceName`

Existing Arc Machine resource name.

- Required: Yes
- Type: string

### Parameter: `customLocation`

Resource ID of the associated custom location.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the virtual machine instance.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual machine instance. |
| `resourceGroupName` | string | The resource group of the virtual machine instance. |
| `resourceId` | string | The resource ID of the virtual machine instance. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
