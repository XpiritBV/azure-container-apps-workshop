param location string
param environmentId string
param containerAppName string
param ingressIsExternal bool
param image string
param environmentVariables array
param secrets array = []
param revisionMode string = 'Single'
param scaling object
param revisionSuffix string

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      activeRevisionsMode: revisionMode
      secrets: secrets
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
      revisionSuffix: revisionSuffix
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
