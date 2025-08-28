// az deployment sub create --template-file .\aks.bicep -l 'Southeast Asia'
targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with connected cluster.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-hangxutest5-kc-flux-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'flux'

param clusterName string = 'hangxutest5flux01'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: resourceGroupName
}

// resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-01-01' existing = {
//   name: clusterName
//   scope: resourceGroup
// }

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: 'test-${serviceShort}-${iteration}'
    params: {
      name: 'flux'
      clusterName: clusterName
      clusterType: 'managedCluster'
      extensionType: 'microsoft.flux'
      releaseNamespace: 'flux-system'
      releaseTrain: 'Stable'
      configurationSettings: {
        'workloadIdentity.azureClientId': 'd888c989-7fab-48b4-9e22-7ad8c289e649'
        'workloadIdentity.azureTenantId': '72f988bf-86f1-41af-91ab-2d7cd011db47'
        'workloadIdentity.enable': 'true'
      }

      fluxConfigurations: [
        {
          namespace: 'flux-system'
          scope: 'cluster'
          sourceKind: 'GitRepository'
          gitRepository: {
            repositoryRef: {
              branch: 'main'
            }
            provider: 'Azure'
            sshKnownHosts: ''
            syncIntervalInSeconds: 300
            timeoutInSeconds: 180
            url: 'https://dev.azure.com/xuhangyu/_git/fluxextension'
          }
          kustomizations: {
            unified: {
              path: './cluster-manifests'
            }
          }
          suspend: false
        }
      ]
      // fluxConfigurations: [
      //   {
      //     namespace: 'flux-system'
      //     scope: 'cluster'
      //     gitRepository: {
      //       repositoryRef: {
      //         branch: 'main'
      //       }
      //       sshKnownHosts: ''
      //       syncIntervalInSeconds: 300
      //       timeoutInSeconds: 180
      //       url: 'https://github.com/mspnp/aks-baseline'
      //     }
      //     kustomizations: {
      //       unified: {
      //         path: './cluster-manifests'
      //       }
      //     }
      //     suspend: false
      //   }
      // ]
    }
  }
]
