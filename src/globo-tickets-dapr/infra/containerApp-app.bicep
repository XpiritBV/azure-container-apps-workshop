param location string = resourceGroup().location
param environmentId string

param containerAppName string

param containerRegistry string
param containerRegistryUsername string
param registryPassword string

param ingressIsExternal bool

param image string
param environmentVariables array

param secrets array = []

param revisionMode string = 'Single'

param scaling object

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      activeRevisionsMode: revisionMode
      secrets: secrets
      registries:[
        {
          server: containerRegistry
          username: containerRegistryUsername
          passwordSecretRef: registryPassword
        }
      ]
      ingress: {
        external: ingressIsExternal
        targetPort: 80
      }
      dapr: {
        enabled: true
        appPort: 80
        appId: containerAppName
      }
    }
    template: {
      containers: [
        {
          image: image
          name: containerAppName
          env: environmentVariables
        }
      ]
      scale: scaling
    }
  }
}

output url string = 'https://${containerApp.properties.configuration.ingress.fqdn}'
