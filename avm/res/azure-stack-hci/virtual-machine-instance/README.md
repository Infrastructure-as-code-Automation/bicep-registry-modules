# Azure Stack HCI Virtual Machine Instance `[Microsoft.AzureStackHCI/virtualMachineInstances]`

This module deploys an Azure Stack HCI Virtual Machine Instance scoped to an Arc machine.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.AzureStackHCI/virtualMachineInstances` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/2024-01-01/virtualMachineInstances) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineInstance 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>' = {
  name: 'virtualMachineInstanceDeployment'
  params: {
    // Required parameters
    arcMachineName: '<arcMachineName>'
    customLocationResourceId: '<customLocationResourceId>'
    networkProfile: {
      networkInterfaces: [
        {
          id: '<id>'
        }
      ]
    }
    storageProfile: {
      imageReference: {
        id: '<id>'
      }
    }
    // Non-required parameters
    hardwareProfile: {
      memoryMB: 4096
      processors: 2
      vmSize: 'Custom'
    }
    osProfile: {
      adminPassword: '<adminPassword>'
      adminUsername: 'vmadmin'
      computerName: 'ashvmiminvm'
      windowsConfiguration: {
        provisionVMAgent: true
        provisionVMConfigAgent: true
      }
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
    "arcMachineName": {
      "value": "<arcMachineName>"
    },
    "customLocationResourceId": {
      "value": "<customLocationResourceId>"
    },
    "networkProfile": {
      "value": {
        "networkInterfaces": [
          {
            "id": "<id>"
          }
        ]
      }
    },
    "storageProfile": {
      "value": {
        "imageReference": {
          "id": "<id>"
        }
      }
    },
    // Non-required parameters
    "hardwareProfile": {
      "value": {
        "memoryMB": 4096,
        "processors": 2,
        "vmSize": "Custom"
      }
    },
    "osProfile": {
      "value": {
        "adminPassword": "<adminPassword>",
        "adminUsername": "vmadmin",
        "computerName": "ashvmiminvm",
        "windowsConfiguration": {
          "provisionVMAgent": true,
          "provisionVMConfigAgent": true
        }
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
param arcMachineName = '<arcMachineName>'
param customLocationResourceId = '<customLocationResourceId>'
param networkProfile = {
  networkInterfaces: [
    {
      id: '<id>'
    }
  ]
}
param storageProfile = {
  imageReference: {
    id: '<id>'
  }
}
// Non-required parameters
param hardwareProfile = {
  memoryMB: 4096
  processors: 2
  vmSize: 'Custom'
}
param osProfile = {
  adminPassword: '<adminPassword>'
  adminUsername: 'vmadmin'
  computerName: 'ashvmiminvm'
  windowsConfiguration: {
    provisionVMAgent: true
    provisionVMConfigAgent: true
  }
}
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineInstance 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>' = {
  name: 'virtualMachineInstanceDeployment'
  params: {
    // Required parameters
    arcMachineName: '<arcMachineName>'
    customLocationResourceId: '<customLocationResourceId>'
    networkProfile: {
      networkInterfaces: [
        {
          id: '<id>'
        }
      ]
    }
    storageProfile: {
      imageReference: {
        id: '<id>'
      }
    }
    // Non-required parameters
    hardwareProfile: {
      dynamicMemoryConfig: {
        maximumMemoryMB: 16384
        minimumMemoryMB: 4096
        targetMemoryBuffer: 20
      }
      memoryMB: 8192
      processors: 4
      vmSize: 'Custom'
    }
    identity: {
      type: 'SystemAssigned'
    }
    osProfile: {
      adminPassword: '<adminPassword>'
      adminUsername: 'vmadmin'
      computerName: 'ashvmiwafvm'
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        provisionVMConfigAgent: true
        timeZone: 'UTC'
      }
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'User'
        roleDefinitionIdOrName: 'Azure Stack HCI VM Reader'
      }
    ]
    securityProfile: {
      enableTPM: true
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
      }
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
    "arcMachineName": {
      "value": "<arcMachineName>"
    },
    "customLocationResourceId": {
      "value": "<customLocationResourceId>"
    },
    "networkProfile": {
      "value": {
        "networkInterfaces": [
          {
            "id": "<id>"
          }
        ]
      }
    },
    "storageProfile": {
      "value": {
        "imageReference": {
          "id": "<id>"
        }
      }
    },
    // Non-required parameters
    "hardwareProfile": {
      "value": {
        "dynamicMemoryConfig": {
          "maximumMemoryMB": 16384,
          "minimumMemoryMB": 4096,
          "targetMemoryBuffer": 20
        },
        "memoryMB": 8192,
        "processors": 4,
        "vmSize": "Custom"
      }
    },
    "identity": {
      "value": {
        "type": "SystemAssigned"
      }
    },
    "osProfile": {
      "value": {
        "adminPassword": "<adminPassword>",
        "adminUsername": "vmadmin",
        "computerName": "ashvmiwafvm",
        "windowsConfiguration": {
          "enableAutomaticUpdates": true,
          "provisionVMAgent": true,
          "provisionVMConfigAgent": true,
          "timeZone": "UTC"
        }
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "User",
          "roleDefinitionIdOrName": "Azure Stack HCI VM Reader"
        }
      ]
    },
    "securityProfile": {
      "value": {
        "enableTPM": true,
        "securityType": "TrustedLaunch",
        "uefiSettings": {
          "secureBootEnabled": true
        }
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
param arcMachineName = '<arcMachineName>'
param customLocationResourceId = '<customLocationResourceId>'
param networkProfile = {
  networkInterfaces: [
    {
      id: '<id>'
    }
  ]
}
param storageProfile = {
  imageReference: {
    id: '<id>'
  }
}
// Non-required parameters
param hardwareProfile = {
  dynamicMemoryConfig: {
    maximumMemoryMB: 16384
    minimumMemoryMB: 4096
    targetMemoryBuffer: 20
  }
  memoryMB: 8192
  processors: 4
  vmSize: 'Custom'
}
param identity = {
  type: 'SystemAssigned'
}
param osProfile = {
  adminPassword: '<adminPassword>'
  adminUsername: 'vmadmin'
  computerName: 'ashvmiwafvm'
  windowsConfiguration: {
    enableAutomaticUpdates: true
    provisionVMAgent: true
    provisionVMConfigAgent: true
    timeZone: 'UTC'
  }
}
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'User'
    roleDefinitionIdOrName: 'Azure Stack HCI VM Reader'
  }
]
param securityProfile = {
  enableTPM: true
  securityType: 'TrustedLaunch'
  uefiSettings: {
    secureBootEnabled: true
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`arcMachineName`](#parameter-arcmachinename) | string | The name of the Azure Arc machine that will host the virtual machine instance. |
| [`customLocationResourceId`](#parameter-customlocationresourceid) | string | The custom location resource ID. |
| [`networkProfile`](#parameter-networkprofile) | object | The network profile configuration. |
| [`storageProfile`](#parameter-storageprofile) | object | The storage profile configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`guestAgentInstallStatus`](#parameter-guestagentinstallstatus) | object | The guest agent install status. |
| [`hardwareProfile`](#parameter-hardwareprofile) | object | The hardware profile configuration. |
| [`httpProxyConfig`](#parameter-httpproxyconfig) | object | The HTTP proxy configuration. |
| [`identity`](#parameter-identity) | object | Specifies the identity for the virtual machine. |
| [`name`](#parameter-name) | string | The name of the virtual machine instance. Must be "default". |
| [`osProfile`](#parameter-osprofile) | object | The OS profile configuration. |
| [`resourceUid`](#parameter-resourceuid) | string | The resource UID. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityProfile`](#parameter-securityprofile) | object | The security profile configuration. |

### Parameter: `arcMachineName`

The name of the Azure Arc machine that will host the virtual machine instance.

- Required: Yes
- Type: string

### Parameter: `customLocationResourceId`

The custom location resource ID.

- Required: Yes
- Type: string

### Parameter: `networkProfile`

The network profile configuration.

- Required: Yes
- Type: object

### Parameter: `storageProfile`

The storage profile configuration.

- Required: Yes
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `guestAgentInstallStatus`

The guest agent install status.

- Required: No
- Type: object

### Parameter: `hardwareProfile`

The hardware profile configuration.

- Required: No
- Type: object

### Parameter: `httpProxyConfig`

The HTTP proxy configuration.

- Required: No
- Type: object

### Parameter: `identity`

Specifies the identity for the virtual machine.

- Required: No
- Type: object

### Parameter: `name`

The name of the virtual machine instance. Must be "default".

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `osProfile`

The OS profile configuration.

- Required: No
- Type: object

### Parameter: `resourceUid`

The resource UID.

- Required: No
- Type: string

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'User Access Administrator'`
  - `'Role Based Access Control Administrator'`
  - `'Azure Stack HCI VM Contributor'`
  - `'Azure Stack HCI VM Reader'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `securityProfile`

The security profile configuration.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `instanceView` | object | The instance view of the virtual machine instance. |
| `location` | string | The location of the virtual machine instance. |
| `name` | string | The name of the virtual machine instance. |
| `provisioningState` | string | The provisioning state of the virtual machine instance. |
| `resourceGroupName` | string | The resource group of the virtual machine instance. |
| `resourceId` | string | The resource ID of the virtual machine instance. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
