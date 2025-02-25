metadata name = 'Azure Stack HCI Virtual Machine Instance'
metadata description = 'This module deploys an Azure Stack HCI virtual machine.'

@description('Required. Name of the virtual machine instance.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. Resource ID of the associated custom location.')
param customLocation string

@description('Required. Existing Arc Machine resource name.')
param arcMachineResourceName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Hardware profile configuration')
param hardwareProfile hardwareProfileType

@description('HTTP proxy configuration')
param httpProxyConfig httpProxyConfigType = {}

@description('Network profile configuration')
param networkProfile networkProfileType

@description('OS profile configuration')
param osProfile osProfileType

@description('Security profile configuration')
param securityProfile securityProfileType = { uefiSettings: { secureBootEnabled: true } }

@description('Storage profile configuration')
param storageProfile storageProfileType

@description('Resource UID')
param resourceUid string = ''

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.azurestackhci-virtualmachineinstance.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource existingMachine 'Microsoft.HybridCompute/machines@2024-07-10' existing = {
  name: arcMachineResourceName
}

resource virtualMachineInstance 'Microsoft.AzureStackHCI/virtualMachineInstances@2024-08-01-preview' = {
  name: name
  tags: tags
  extendedLocation: {
    type: 'CustomLocation'
    name: customLocation
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      memoryMB: hardwareProfile.memoryMB
      processors: hardwareProfile.processors
      vmSize: empty(hardwareProfile.?vmSize) ? 'Custom' : hardwareProfile.?vmSize
      dynamicMemoryConfig: hardwareProfile.?dynamicMemoryConfig
    }
    httpProxyConfig: empty(httpProxyConfig) ? null : httpProxyConfig
    networkProfile: networkProfile
    osProfile: osProfile
    resourceUid: empty(resourceUid) ? null : resourceUid
    securityProfile: empty(securityProfile) ? null : securityProfile
    storageProfile: storageProfile
  }
  scope: existingMachine
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the virtual machine instance.')
output name string = virtualMachineInstance.name

@description('The resource ID of the virtual machine instance.')
output resourceId string = virtualMachineInstance.id

@description('The resource group of the virtual machine instance.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

@export()
@description('Type definition for dynamic memory configuration.')
type dynamicMemoryConfigType = {
  @description('Required. Maximum memory in MB.')
  maximumMemoryMB: int

  @description('Required. Minimum memory in MB.')
  minimumMemoryMB: int

  @description('Required. Target memory buffer percentage.')
  targetMemoryBuffer: int
}

@export()
@description('Type definition for hardware profile.')
type hardwareProfileType = {
  @description('Optional. Dynamic memory configuration.')
  dynamicMemoryConfig: dynamicMemoryConfigType?

  @description('Required. Memory in MB.')
  memoryMB: int

  @description('Required. Number of processors.')
  processors: int

  @description('Optional. Size of the virtual machine.')
  vmSize: string?
}

@export()
@description('Type definition for HTTP proxy configuration.')
type httpProxyConfigType = {
  @description('Optional. HTTP proxy URL.')
  httpProxy: string?

  @description('Optional. HTTPS proxy URL.')
  httpsProxy: string?

  @description('Optional. List of addresses that should bypass the proxy.')
  noProxy: string[]?

  @description('Optional. Trusted CA certificate.')
  trustedCa: string?
}

@export()
@description('Type definition for network interface.')
type networkInterfaceType = {
  @description('ID of the network interface')
  id: string
}

@export()
@description('Type definition for network profile.')
type networkProfileType = {
  @description('List of network interfaces.')
  networkInterfaces: networkInterfaceType[]
}

@export()
@description('Type definition for SSH public key.')
type sshPublicKeyType = {
  @description('SSH public key data.')
  keyData: string

  @description('Path for the SSH public key.')
  path: string
}

@export()
@description('Type definition for SSH configuration.')
type sshConfigType = {
  @description('List of SSH public keys.')
  publicKeys: sshPublicKeyType[]
}

@export()
@description('Type definition for Linux configuration.')
type linuxConfigurationType = {
  @description('Whether to disable password authentication.')
  disablePasswordAuthentication: bool

  @description('Whether to provision VM agent.')
  provisionVMAgent: bool

  @description('Whether to provision VM config agent.')
  provisionVMConfigAgent: bool

  @description('Optional. SSH configuration')
  ssh: sshConfigType?
}

@export()
@description('Type definition for Windows configuration.')
type windowsConfigurationType = {
  @description('Whether to enable automatic updates.')
  enableAutomaticUpdates: bool

  @description('Whether to provision VM agent.')
  provisionVMAgent: bool

  @description('Whether to provision VM config agent.')
  provisionVMConfigAgent: bool

  @description('Optional. SSH configuration.')
  ssh: sshConfigType?

  @description('Optional. Time zone.')
  timeZone: string?
}

@export()
@description('Type definition for OS profile.')
type osProfileType = {
  @description('Admin password.')
  adminPassword: string

  @description('Admin username.')
  adminUsername: string

  @description('Computer name.')
  computerName: string

  @description('Optional. Linux configuration.')
  linuxConfiguration: linuxConfigurationType?

  @description('Optional. Windows configuration.')
  windowsConfiguration: windowsConfigurationType?
}

@export()
@description('Type definition for UEFI settings.')
type uefiSettingsType = {
  @description('Required. Whether secure boot is enabled.')
  secureBootEnabled: bool
}

@export()
@description('Type definition for security profile.')
type securityProfileType = {
  @description('Whether TPM is enabled.')
  enableTPM: bool?

  @description('Security type.')
  securityType: string?

  @description('Required. UEFI settings.')
  uefiSettings: uefiSettingsType
}

@export()
@description('Type definition for data disk.')
type dataDiskType = {
  @description('ID of the data disk.')
  id: string
}

@export()
@description('Type definition for image reference.')
type imageReferenceType = {
  @description('ID of the image.')
  id: string
}

@export()
@description('Type definition for OS disk.')
type osDiskType = {
  @description('ID of the OS disk.')
  id: string

  @description('OS type.')
  osType: string
}

@export()
@description('Type definition for storage profile.')
type storageProfileType = {
  @description('Optional. List of data disks.')
  dataDisks: dataDiskType[]?

  @description('Optional. Image reference.')
  imageReference: imageReferenceType?

  @description('OS disk.')
  osDisk: osDiskType

  @description('Optional. VM config storage path ID.')
  vmConfigStoragePathId: string?
}
