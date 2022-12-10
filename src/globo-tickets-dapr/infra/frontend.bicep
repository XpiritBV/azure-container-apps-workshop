param location string = resourceGroup().location

param containerAppName string = 'frontend'

param containerRegistry string
param containerRegistryUsername string
param registryPassword string

param ingressIsExternal bool = true

param image string
param secrets array = []
param revisionMode string = 'Single'

param scaling object = {
  minReplicas: 1
  maxReplicas: 1
}

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: 'globotickets'
}


resource frontend 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: location
  properties: {
    managedEnvironmentId: containerAppEnv.id
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
          env: [
            {
              name: 'ASPNETCORE_ENVIRONMENT'
              value: 'Development'
            }
          ]
        }
      ]
      scale: scaling
      revisionSuffix: 'geert'
    }
  }
}

output url string = 'https://${containerApp.properties.configuration.ingress.fqdn}'
