# Lab 6: Using Dapr in Azure Container Apps

In the previous lab we explored Dapr locally and in earlier labs you deployed Globo Tickets to Azure Container Apps. Now it's time to combine the two. Let's add Dapr to our Apps.

> Tips:
>
> - You can either use the Bicep files in `/src/globo-tickets-dapr-aca/infra` or continue with whatever you used in earlier labs. The examples in this lab are based on Bicep though and if you decide not to use them, you need to create the CosmosDB and Azure ServiceBus resources in another way.
> - For every step there is a working example in `/src/globo-tickets-dapr-aca-scaling/final/infra` directory if you are having trouble.

## 1. Enabling Application Insights for Dapr

One of the benefits of using Dapr in ACA is the integration with Application Insights. Enable this for some nice out of the box telemetry.
Configure the 'daprAIInstrumentationKey' parameter of your Container App Environment and set the value to the InstrumentationKey of your Application Insights instance.

In part 5 of this lab we'll see what that gives us, first we need to start using Dapr.

> Tip: You can only set the instrumentation key when creating the environment, not afterwards.

## 2. Adding Dapr Components to the Environment

So far we've used Dapr components locally. They were pointing to a local Redis container instance for both the 'pubsub' and 'statestore' components.
In Azure Container Apps, components are created at the environment level and can be scoped to restrict access to certain apps.

The Dapr component of type [state.azure.cosmosdb](https://docs.dapr.io/reference/components-reference/supported-state-stores/setup-azure-cosmosdb/) is already created for you.
Create a [Dapr component](https://learn.microsoft.com/en-us/azure/templates/microsoft.app/managedenvironments/daprcomponents?pivots=deployment-language-bicep) in your IAC of type [pubsub.azure.servicebus](https://docs.dapr.io/reference/components-reference/supported-pubsub/setup-azure-servicebus/) yourself.

## 3. Enabling the Dapr sidecar for the Apps

You will also need to enable the Dapr sidecar for each of your apps. As we want every app to have a Dapr sidecar, add the 'dapr' to the configuration section of the containerapp resource in `containerapp.bicep`. Enable Dapr, set the appPort to 80 and the appId to the containerAppName.

## 4. Deploy the Azure Container App Environment and the Globo Tickets App

Time to deploy everything. Open a terminal and navigate to the `/src/globo-tickets-dapr-aca` directory. Use the following commands to start deployment.

- az login
- az account set --subscription _yoursubscriptionid_
- az group create --location "westeurope" --resource-group "rg-globotickets"
- az deployment group create -g "rg-globotickets" -f "main.bicep" -p frontendImage="ghcr.io/xpiritbv/azure-container-apps-workshop/frontend-dapr:main" catalogImage="ghcr.io/xpiritbv/azure-container-apps-workshop/catalog-dapr:main" orderingImage="ghcr.io/xpiritbv/azure-container-apps-workshop/ordering-dapr:main" appName="globotickets"

Time to grab a coffee and pray ;)

When it is done, find the URL for the ca-frontend app in the Azure Portal or use the Azure CLI to look it up. Test if everything works and order a few things.
If things aren't going smoothly, ask for help or (depending on where things went wrong) have a look at the logs to try and figure out what went wrong. See the next assignment on how to view the logs of the Dapr sidecar.

## 5. Viewing the sidecar logs

### 5.1 Querying log analytics

### 5.2 Using log stream

## 6. Have a look at the Application Map
