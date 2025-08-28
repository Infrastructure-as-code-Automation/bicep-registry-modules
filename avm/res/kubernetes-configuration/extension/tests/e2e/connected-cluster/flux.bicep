@description('Required. The name of the AKS cluster extension to create.')
param clusterExtensionName string = 'flux01'

param clusterName string = 'hangxutest7flux01'

resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-01-01' existing = {
  name: clusterName
  scope: resourceGroup()
}

resource extension 'Microsoft.KubernetesConfiguration/extensions@2024-11-01' = {
  scope: connectedCluster
  name: clusterExtensionName
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    extensionType: 'microsoft.flux'
    autoUpgradeMinorVersion: true
  }
}
