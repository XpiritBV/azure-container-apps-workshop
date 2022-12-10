param busName string = 'globoticketsBus'
param location string = resourceGroup().location

resource servicebus 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' = {
  name: busName
  location: location
  sku: {
    name: 'Standard'
  }
}

resource servicebusTopic 'Microsoft.ServiceBus/namespaces/topics@2022-01-01-preview' = {
  name: 'orders'
  parent: servicebus
}

var serviceBusEndpoint = '${servicebus.id}/AuthorizationRules/RootManageSharedAccessKey'
output serviceBusConnectionString string = listKeys(serviceBusEndpoint, servicebus.apiVersion).primaryConnectionString
