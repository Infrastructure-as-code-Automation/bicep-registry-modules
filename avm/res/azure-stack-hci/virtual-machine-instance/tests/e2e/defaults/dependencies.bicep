targetScope = 'resourceGroup'

metadata name = 'Using WAF-aligned config'
metadata description = 'This instance deploys the module with WAF aligned parameters.'

// ========== //
// Parameters //
// ========== //

@description('Required. The location to deploy resources to.')
param resourceLocation string

@description('Required. The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01.')
param customLocationName string

// ============ //
// Dependencies //
// ============ //

resource hciWinImage 'Microsoft.AzureStackHCI/marketplaceGalleryImages@2024-01-01' = {
  name: 'winServer2022-01'
  location: resourceLocation
  extendedLocation: {
    name: customLocationName
    type: 'CustomLocation'
  }
  properties: {
    containerId: null
    osType: 'Windows'
    hyperVGeneration: 'V2'
    identifier: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
    }
    version: {
      name: '20348.2113.231109'
      properties: {
        storageProfile: {
          osDiskImage: {}
        }
      }
    }
  }
}

output resourceId string = hciWinImage.id
