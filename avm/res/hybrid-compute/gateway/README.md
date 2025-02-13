# Hybrid Compute Gateways `[Microsoft.HybridCompute/gateways]`

<Add description>

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.HybridCompute/gateways` | [2024-11-10-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HybridCompute/2024-11-10-preview/gateways) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/hybrid-compute/gateway:<version>`.

- [Creates an Arc Gateway using only the defeaults](#example-1-creates-an-arc-gateway-using-only-the-defeaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Creates an Arc Gateway using only the defeaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module gateway 'br/public:avm/res/hybrid-compute/gateway:<version>' = {
  name: 'gatewayDeployment'
  params: {
    // Required parameters
    name: 'arcgwcimin001'
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
    "name": {
      "value": "arcgwcimin001"
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
using 'br/public:avm/res/hybrid-compute/gateway:<version>'

// Required parameters
param name = 'arcgwcimin001'
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
module gateway 'br/public:avm/res/hybrid-compute/gateway:<version>' = {
  name: 'gatewayDeployment'
  params: {
    // Required parameters
    name: 'arcgwciwaf001'
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
    "name": {
      "value": "arcgwciwaf001"
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
using 'br/public:avm/res/hybrid-compute/gateway:<version>'

// Required parameters
param name = 'arcgwciwaf001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the gateway to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedFeatures`](#parameter-allowedfeatures) | array | List of features allowed on the gateway. Allowed values are: ['RemoteApp', 'RemoteDesktop', 'RemotePowerShell', 'RemoteSSH', 'RemoteSFTP', 'RemoteVNC', 'RemoteWinRM'] |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`gatewayType`](#parameter-gatewaytype) | string | Type of gateway to create, the only allowed value is Public. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the gateway to create.

- Required: Yes
- Type: string

### Parameter: `allowedFeatures`

List of features allowed on the gateway. Allowed values are: ['RemoteApp', 'RemoteDesktop', 'RemotePowerShell', 'RemoteSSH', 'RemoteSFTP', 'RemoteVNC', 'RemoteWinRM']

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `gatewayType`

Type of gateway to create, the only allowed value is Public.

- Required: No
- Type: string
- Default: `'Public'`
- Allowed:
  ```Bicep
  [
    'Public'
  ]
  ```

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
| `location` | string | The location the gateway was deployed into. |
| `name` | string | The name of the gateway. |
| `resourceGroupName` | string | The name of the resource group the gateway was created in. |
| `resourceId` | string | The resource ID of the gateway. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
