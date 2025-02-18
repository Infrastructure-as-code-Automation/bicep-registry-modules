# Azure Stack HCI Virtual Hard Disk `[Microsoft.AzureStackHCI/virtualHardDisks]`

This module deploys an Azure Stack HCI virtual hard disk.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AzureStackHCI/virtualHardDisks` | [2025-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/2025-02-01-preview/virtualHardDisks) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/virtual-hard-disk:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualHardDisk 'br/public:avm/res/azure-stack-hci/virtual-hard-disk:<version>' = {
  name: 'virtualHardDiskDeployment'
  params: {
    // Required parameters
    customLocationId: '<customLocationId>'
    diskSizeGB: 4
    dynamic: false
    name: 'ashvhdminvhd'
    // Non-required parameters
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
    "customLocationId": {
      "value": "<customLocationId>"
    },
    "diskSizeGB": {
      "value": 4
    },
    "dynamic": {
      "value": false
    },
    "name": {
      "value": "ashvhdminvhd"
    },
    // Non-required parameters
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
using 'br/public:avm/res/azure-stack-hci/virtual-hard-disk:<version>'

// Required parameters
param customLocationId = '<customLocationId>'
param diskSizeGB = 4
param dynamic = false
param name = 'ashvhdminvhd'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualHardDisk 'br/public:avm/res/azure-stack-hci/virtual-hard-disk:<version>' = {
  name: 'virtualHardDiskDeployment'
  params: {
    // Required parameters
    customLocationId: '<customLocationId>'
    diskSizeGB: 4
    dynamic: true
    name: 'ashvhdwafvhd'
    // Non-required parameters
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
    "customLocationId": {
      "value": "<customLocationId>"
    },
    "diskSizeGB": {
      "value": 4
    },
    "dynamic": {
      "value": true
    },
    "name": {
      "value": "ashvhdwafvhd"
    },
    // Non-required parameters
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
using 'br/public:avm/res/azure-stack-hci/virtual-hard-disk:<version>'

// Required parameters
param customLocationId = '<customLocationId>'
param diskSizeGB = 4
param dynamic = true
param name = 'ashvhdwafvhd'
// Non-required parameters
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
| [`customLocationId`](#parameter-customlocationid) | string | Resource ID of the associated custom location. |
| [`diskSizeGB`](#parameter-disksizegb) | int | The size of the disk in GB. |
| [`dynamic`](#parameter-dynamic) | bool | The disk type. |
| [`name`](#parameter-name) | string | Name of the resource to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerId`](#parameter-containerid) | string | The container ID. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `customLocationId`

Resource ID of the associated custom location.

- Required: Yes
- Type: string

### Parameter: `diskSizeGB`

The size of the disk in GB.

- Required: Yes
- Type: int

### Parameter: `dynamic`

The disk type.

- Required: Yes
- Type: bool

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `containerId`

The container ID.

- Required: No
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
| `location` | string | The location of the virtual hard disk. |
| `name` | string | The name of the virtual hard disk. |
| `resourceGroupName` | string | The resource group of the virtual hard disk. |
| `resourceId` | string | The resource ID of the virtual hard disk. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
