// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. The custom location ID.')
param customLocationResourceId string

@description('Required. Operating system type that the gallery image uses.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Required. The gallery image identifier configuration of publisher.')
param publisher string

@description('Required. The gallery image identifier configuration of offer.')
param offer string

@description('Required. The gallery image identifier configuration of SKU.')
param sku string

@description('Optional. The hypervisor generation of the Virtual Machine.')
@allowed([
  'V1'
  'V2'
])
param hyperVGeneration string = 'V2'

@description('Optional. Datasource for the gallery image when provisioning with cloud-init.')
@allowed([
  'NoCloud'
  'Azure'
])
param cloudInitDataSource string?

@description('Optional. Storage Container resourceId of the storage container to be used for marketplace gallery image.')
param containerResourceId string?

@description('Required. Gallery image version name.')
param versionName string

// ============== //
//   Resources   //
// ============== //

resource marketplaceGalleryImage 'Microsoft.AzureStackHCI/marketplaceGalleryImages@2025-04-01-preview' = {
  name: name
  location: location
  extendedLocation: {
    name: customLocationResourceId
    type: 'CustomLocation'
  }
  properties: {
    cloudInitDataSource: cloudInitDataSource
    containerId: containerResourceId
    hyperVGeneration: hyperVGeneration
    identifier: {
      publisher: publisher
      offer: offer
      sku: sku
    }
    osType: osType
    version: {
      name: versionName
    }
  }
}
