# Lab 4: Exploring the observability of an Azure Container App

Deploying an app to the cloud is only the first step. After it is there you need to be able to check how your application is doing. In this lab we're going to have a look on how to do that.

## 1. Viewing logs in the portal.
- Go to your Azure Container App. 
- In the menu on the left you'll have a header called `Monitoring`. Explore the different options you have here
  - **Metrics**: Metrics give you an insight on how your application is doing looking at it from the outside. How is the CPU load?, how many requests were made to the service?
  - **Logs**: Logs give you access to the raw Azure Log Analytics storage where you can do all kinds of queries in KQL. It stores both the application logs (`ConsoleLogs`) which can be used to see what the application outputs but it also contains the (`SystemLogs`) which can be very useful when your container app doesn't start. You can also create queries with visuals here to store on a dashboard to give insights at a glance.
  - **Log stream**: The log stream is an easy way to have a look at a specific container console log. You can select the replica but also the container so if you want to look at the dapr logs you can select the dapr sidecar here as well.
  - **Console**: Sometimes you need to actually get into a running container to see what is going on. By using the console you can connect to a running container to see what is happening on the inside. Use with caution because you can also break things while in here!
  - **Advisor recommendations**: The advisor recommendations are not 100% a monitoring item. It can give you good recommendations on making your container app more resilient or fault tolerent so have a look here some times to see what you could improve!




TODO
  - cli see output container
  - cli interactive into container