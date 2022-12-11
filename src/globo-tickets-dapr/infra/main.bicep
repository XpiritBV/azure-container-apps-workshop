param appName string = 'globotickets'
param location string = resourceGroup().location

param frontendImage string
param catalogImage string
param orderingImage string
param containerRegistry string
param containerRegistryUsername string = ''

@secure()
param containerRegistryPassword string = ''

var registryPasswordSecret = 'registry-password'

module environment 'modules/containerapp-env.bicep' = {
  name: '${deployment().name}-environment'
  params: {
    environmentName: appName
    location: location
    appInsightsName: '${appName}-ai'
    logAnalyticsWorkspaceName: '${appName}-la'
  }
}

module frontend 'modules/containerapp.bicep' = {
  name: '${deployment().name}-frontendApp'
  params: {
    containerAppName: 'frontend'
    environmentId: environment.outputs.environmentId
    location: location
    ingressIsExternal: true
    image: frontendImage
    containerRegistry: containerRegistry
    registryPassword: registryPasswordSecret
    containerRegistryUsername: containerRegistryUsername
    revisionMode: 'Multiple'
    secrets: [
      {
        name: registryPasswordSecret
        value: containerRegistryPassword
      }
      {
        name: 'cosmosprimarymasterkey'
        value: cosmosdb.outputs.primaryMasterKey
      }
      {
        name: 'cosmosdocumentendpoint'
        value: cosmosdb.outputs.documentEndpoint
      }
      {
        name: 'servicebusconnectionstring'
        value: servicebus.outputs.serviceBusConnectionString
      }      
    ]
    environmentVariables: [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
      {
        name: 'ApiConfigs__ConcertCatalog__Uri'
        value: catalog.outputs.url
      }
      {
        name: 'ApiConfigs__Ordering__Uri'
        value: ordering.outputs.url
      }
    ]
    scaling: {
      minReplicas: 1
      maxReplicas: 1
    }
  }
}

module catalog 'modules/containerapp.bicep' = {
  name: '${deployment().name}-catalogApp'
  params: {
    containerAppName: 'catalog'
    environmentId: environment.outputs.environmentId
    location: location
    ingressIsExternal: false
    image: catalogImage
    containerRegistry: containerRegistry
    registryPassword: registryPasswordSecret
    containerRegistryUsername: containerRegistryUsername
    secrets: [
      {
        name: registryPasswordSecret
        value: containerRegistryPassword
      }
    ]
    environmentVariables: [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
    ]
    scaling: {
      minReplicas: 1
      maxReplicas: 1
    }
  }
}

module ordering 'modules/containerapp.bicep' = {
  name: '${deployment().name}-orderingApp'
  params: {
    containerAppName: 'ordering'
    environmentId: environment.outputs.environmentId
    location: location
    ingressIsExternal: false
    image: orderingImage
    containerRegistry: containerRegistry
    registryPassword: registryPasswordSecret
    containerRegistryUsername: containerRegistryUsername
    secrets: [
      {
        name: registryPasswordSecret
        value: containerRegistryPassword
      }
      {
        name: 'servicebusconnectionstring'
        value: servicebus.outputs.serviceBusConnectionString
      }
    ]
    environmentVariables: [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
    ]
    scaling: {
      minReplicas: 0
      maxReplicas: 10
      rules: [
       {
         name: 'queue-based-autoscaling'
         custom: {
           type: 'azure-servicebus'
           metadata: {
             topicName: 'orders'
             messageCount: '10'
             activationMessageCount: '1'
           }
           auth: [
             {
               secretRef: 'servicebusconnectionstring'
               triggerParameter: 'connection'
             }
           ]
         }
       }
      ]
    }
  }
}

module servicebus 'modules/servicebus.bicep' = {
  name: '${appName}-bus'
  params: {
    busName: '${appName}Bus'
    location: location
  }
}

module cosmosdb 'modules/cosmosdb.bicep' = {
  name: '${appName}-cosmosdb'
  params: {
    accountName: '${appName}-cosmos'
    location: location
    primaryRegion: location
  }
}
