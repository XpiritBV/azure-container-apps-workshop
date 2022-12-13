param environmentName string
param componentName string
@secure()
param serviceBusConnectionString string

resource environment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: environmentName
}

resource pubsubComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-03-01' = {
  name: componentName
  parent: environment
  properties: {
    componentType: 'pubsub.azure.servicebus'
    version: 'v1'
    metadata: [
      {
        name: 'connectionString'
        secretRef: 'servicebusconnectionstring'
      }
    ]
    secrets: [
      {
        name: 'servicebusconnectionstring'
        value: serviceBusConnectionString
      }
    ]
  }
}
