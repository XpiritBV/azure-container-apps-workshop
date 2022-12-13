# Lab 4: Exploring the observability of an Azure Container App

Deploying an app to the cloud is only the first step. After it is there you need to be able to check how your application is doing. In this lab we're going to have a look on how to do that.

## 1. Viewing logs in the portal.
- Go to your Azure Container App. 
- In the menu on the left you'll have a header called `Monitoring`. Explore the different options you have here
  - **Metrics**: Metrics give you an insight on how your application is doing looking at it from the outside. How is the CPU load? How many requests were made to the service? How many replicas are active?
  - **Logs**: Logs give you access to the raw Azure Log Analytics storage where you can do all kinds of queries in KQL. It stores both the application logs (`ConsoleLogs`) which can be used to see what the application outputs but it also contains the (`SystemLogs`) which can be very useful when your container app doesn't start. You can also create queries with visuals here to store on a dashboard to give insights at a glance.
  - **Log stream**: The log stream is an easy way to have a look at a specific container console log. You can select the replica but also the container so if you want to look at the dapr logs you can select the dapr sidecar here as well.
  - **Console**: Sometimes you need to actually get into a running container to see what is going on. By using the console you can connect to a running container to see what is happening on the inside. Use with caution because you can also break things while in here!
  - **Advisor recommendations**: The advisor recommendations are not 100% a monitoring item. It can give you good recommendations on making your container app more resilient or fault tolerent so have a look here some times to see what you could improve!


## 2. Using Azure CLI to view logs & information about your container app
The Azure CLI has a number of features to view information about your running container app. The log stream that you can view in the Azure portal is also available through the CLI. 

1. Try to view the logs of the ordering service using the cli

```bash
az containerapp logs show -n ordering -g globo-tickets --follow
```

2. If you want to know how many instances of a certain container are running you can also do this using the CLI. Try to view how many instances are currently running for the ordering service

```bash
az containerapp replica list -n ordering -g globo-tickets
```

## 3. Using Azure CLI to interact with running container
Sometimes logs are just not enough and you need to fix a running container or see what is going wrong on the file storage of a running container. You can start a interactive session into a running container using the CLI.

1. try to access the front end container using the CLI. You can use sh, zsh or bash.  (sh is the default).

```bash
az containerapp exec -n frontend -g globo-tickets
```

As you can see there are quite some options to see the logs or search for issues of your running application in Container Apps. This completes this lab.