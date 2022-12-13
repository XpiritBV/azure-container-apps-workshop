# Lab 6: Using Dapr in Azure Container Apps

In the previous lab we explored Dapr locally and in earlier labs you deployed Globo Tickets to Azure Container Apps. Now it's time to combine the two. Let's add Dapr to our Apps.

> Tips:
>
> - You can either use the Bicep files in `/src/globo-tickets-dapr-aca/infra` or continue with whatever you used in earlier labs. The examples in this lab are based on Bicep though and if you decide not to use them, you need to create the CosmosDB and Azure ServiceBus resources in another way.
> - For every step there is a working example in `/src/globo-tickets-dapr-aca-scaling/final/infra` directory if you are having trouble.

An example of where the different elements come into play can be seen here:

![Dapr Logs using LA](/labs/img/dapr-aca.png)

## 1. Enabling Application Insights for Dapr

One of the benefits of using Dapr in ACA is the integration with Application Insights. Enable this for some nice out of the box telemetry.
Configure the 'daprAIInstrumentationKey' parameter of your Container App Environment and set the value to the InstrumentationKey of your Application Insights instance.

In part 5 of this lab we'll see what that gives us, first we need to start using Dapr.

> Tip: You can only set the instrumentation key when creating the environment, not afterwards.

## 2. Adding Dapr Components to the Environment

So far we've used Dapr components locally. They were pointing to a local Redis container instance for both the 'pubsub' and 'statestore' components.

In Azure Container Apps, components are created at the environment level. They can be scoped to certain apps, only those apps will load the component. See the specs of all components [here](https://docs.dapr.io/reference/components-reference/).

Now create a [Dapr component](https://learn.microsoft.com/en-us/azure/templates/microsoft.app/managedenvironments/daprcomponents?pivots=deployment-language-bicep) in your IAC of type [pubsub.azure.servicebus](https://docs.dapr.io/reference/components-reference/supported-pubsub/setup-azure-servicebus/). You can use the [state.azure.cosmosdb](https://docs.dapr.io/reference/components-reference/supported-state-stores/setup-azure-cosmosdb/) as an example, it's a bit more complicated to configure so we did that for you.

> Tip: A component is identified by its name. Make sure you use the same name as the Dapr component we were using locally, else your app won't work

## 3. Enabling the Dapr sidecar for the Apps

You will also need to enable the Dapr sidecar for each of your apps. As we want every app to have a Dapr sidecar, add the 'dapr' to the configuration section of the containerapp resource in `containerapp.bicep`. Enable Dapr, set the appPort to 80 and the appId to the containerAppName.

## 4. Deploy the Azure Container App Environment and the Globo Tickets App

Time to deploy everything. Open a terminal and navigate to the `/src/globo-tickets-dapr-aca` directory. Use the following commands to start deployment.

- az login
- az account set --subscription _yoursubscriptionid_
- az group create --location "westeurope" --resource-group "rg-globotickets"
- az deployment group create -g "rg-globotickets" -f "main.bicep" -p frontendImage="ghcr.io/xpiritbv/azure-container-apps-workshop/frontend-dapr:main" catalogImage="ghcr.io/xpiritbv/azure-container-apps-workshop/catalog-dapr:main" orderingImage="ghcr.io/xpiritbv/azure-container-apps-workshop/ordering-dapr:main" appName="globotickets"

Time to grab a coffee and pray you didn't make any mistakes and Azure is in a good mood ;)

When it is done, find the URL for the ca-frontend app in the Azure Portal or use the Azure CLI to look it up. Test if everything works and order a few things.
If things aren't going smoothly, ask for help or (depending on where things went wrong) have a look at the logs to try and figure out what went wrong. See the next assignment on how to view the logs of the Dapr sidecar.

## 5. Viewing the sidecar logs

We already saw how to view the logs of your app in [Lab 4 - Observability](/labs/observability.md). To view the logs of the Dapr sidecar you have 2 options:

- Query log analytics
- Log stream

### 5.1 Querying log analytics

Use the Azure Portal and open Revision Management for an App. Click on the revision and view the console logs. Look for entries that have 'ContainerName_s' set to 'daprd'.

![Dapr Logs using LA](/labs/img/daprlogs.png)

### 5.2 Using log stream

Use the Azure Portal and open the Log Stream of an App. Use the dropdown to select the Dapr container. 

![Dapr Logs using Log Stream](/labs/img/daprlogs2.png)

## 6. Have a look at the Application Map

If you have everything up and running and you used the Globo Tickets app to order a ticket to your favorite show, navigate to Application Insights and have a look at the Application Map. It should look something like the image below.

It's not perfect, but it's a nice bonus. Especially the service to service call is clearly visible. This however is also limited, as it's only between 2 services. So from service A to B works, but if that call also triggered another call from B to C it won't group log these as a single operation.

![Dapr Logs using Log Stream](/labs/img/applicationmap.png)

## 7. Secrets

A quick word about the secrets we've used in this lab. Instead of setting them directly in the component, it is better to create yet another component: a secretstore. This secretstore can be implemented by Azure KeyVault so all your secrets are safe in there. The other Dapr components then reference the secretstore.

There are no assignments for this, but for your information it would look like this:

```yaml
resource daprComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-01-01-preview' = {
  name: secretStoreName
  parent: containerAppsEnvironment
  properties: {
    componentType: 'secretstores.azure.keyvault'
    version: 'v1'
    metadata: [
      {
        name: 'vaultName'
        value: keyVaultName
      }
      {
        name: 'azureClientId'
        value: userAssignedIdentity.properties.clientId
      }      
    ]
  }
}
```

Referencing secrets:

```yaml
resource daprComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-06-01-preview' = {
  name: pubsubName
  parent: containerAppsEnvironment
  properties: {
    componentType: 'pubsub.azure.servicebus'
    version: 'v1'
    metadata: [
      {
        name: 'connectionString'
        secretRef: 'ServicebusConnectionString'
      }
    ]
    secretStoreComponent: secretStoreName
  }
}
```

In KeyVault there would be an entry named 'ServicebusConnectionString'.

> Tip: It is even better to not use secrets at all and use Managed Identities and manage access with that

## 8. Updating Dapr

This is handled by Microsoft :)
