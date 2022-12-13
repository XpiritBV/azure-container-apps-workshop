param appName string
param location string = resourceGroup().location
param frontendImage string
param catalogImage string
param orderingImage string
param revisionSuffix string = ''

var envName = 'cae-${appName}'

module environment 'modules/containerapp-env.bicep' = {
  name: envName
  params: {
    environmentName: envName
    appInsightsName: 'ai-${appName}'
    logAnalyticsWorkspaceName: 'log-${appName}'
    location: location
  }
}

module frontend 'modules/containerapp.bicep' = {
  name: 'frontend'
  params: {
    containerAppName: 'ca-frontend'
    environmentId: environment.outputs.environmentId
    location: location
    ingressIsExternal: true
    image: frontendImage
    revisionSuffix: revisionSuffix
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
  name: 'catalog'
  params: {
    containerAppName: 'ca-catalog'
    environmentId: environment.outputs.environmentId
    location: location
    ingressIsExternal: false
    image: catalogImage
    revisionSuffix: revisionSuffix
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
  name: 'ordering'
  params: {
    containerAppName: 'ca-ordering'
    environmentId: environment.outputs.environmentId
    location: location
    ingressIsExternal: false
    image: orderingImage
    revisionSuffix: revisionSuffix
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

module servicebus 'modules/servicebus.bicep' = {
  name: 'servicebus'
  params: {
    busName: 'sb-${appName}'
    location: location
  }
}

module cosmosdb 'modules/cosmosdb.bicep' = {
  name: 'cosmosdb'
  params: {
    accountName: 'cosmos-${appName}'
    location: location
    primaryRegion: location
  }
}

module daprStateStoreComponent 'modules/containerapp-env-daprcomp-statestore.bicep' = {
  name: 'statestore'
  params: {
    componentName: 'shopstate'
    environmentName: environment.name
    cosmosDocumentEndpoint: cosmosdb.outputs.documentEndpoint
    cosmosPrimaryMasterKey: cosmosdb.outputs.primaryMasterKey
  }
}

module daprPubSubComponent 'modules/containerapp-env-daprcomp-pubsub.bicep' = {
  name: 'pubsub'
  params: {
    //TODO
  }
}
