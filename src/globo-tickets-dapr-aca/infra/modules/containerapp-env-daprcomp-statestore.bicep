param environmentName string
param componentName string
param cosmosDocumentEndpoint string
@secure()
param cosmosPrimaryMasterKey string

resource environment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: environmentName
}

resource shopstateComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-03-01' = {
  name: componentName
  parent: environment
  properties: {
    componentType: 'state.azure.cosmosdb'
    version: 'v1'
    metadata: [
      {
        name: 'url'
        value: cosmosDocumentEndpoint
      }
      {
        name: 'database'
        value: 'basketDb'
      }
      {
        name: 'collection'
        value: 'baskets'
      }
      {
        name: 'masterkey'
        secretRef: 'cosmosprimarymasterkey'
      }
    ]
    secrets: [
      {
        name: 'cosmosprimarymasterkey'
        value: cosmosPrimaryMasterKey
      }
    ]
  }
}
