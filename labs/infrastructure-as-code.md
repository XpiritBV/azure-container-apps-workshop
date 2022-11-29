# Lab 2: Deploying an Azure Container App using Infrastructure as code

## 1. Learning about Globo Tickets
In this lab we'll take a look at an application called Globo Tickets. It's an application that consists of 3 services working together. First of all there is a front end service serving a web shop as a website. This front end service uses the catalog service to retrieve the items & prices to populate the webshop. After that whenever an order is placed this is sent to an ordering service which will handle further processing of this order.

<img src="img/globo-tickets-with-ingress.svg" height=350>

### 1.1. Running Globo Tickets Locally
To get a good feeling of the application you can run the application locally before we actually deploy it in the cloud. We can do this by using `Docker Compose`.
There is a Docker Compose file (`docker-compose.yml`) in the `src/globo-tickets-basic` directory that you could use to run the app locally. 

> Installing Docker Compose: If you have Docker Desktop installed you already have Docker Compose ready to use. If not you can install the compose plugin next to Docker here: https://docs.docker.com/compose/install/

> Tip for running Docker Compose:
> - [`Docker Compose Build`](https://docs.docker.com/engine/reference/commandline/compose_build/)
> - [`Docker Compose Up`](https://docs.docker.com/engine/reference/commandline/compose_up/)

## 2. Deploying Gobo Tickets to Azure Container Apps

### 2.1 Required infrastructure
In [Lab 1 - My first container app](labs/first-container-app.md) we've seen all the requirements we need to create an Azure Container App Environment. Before we can deploy our application we need to create a:

- Azure Log Analytics Workspace
- Azure Container App Environment
- (optional) Application Insights

Since we're not cavemen/women we will create these resources using Infrastructure as Code. You are free to choose your own language if you dare but in this lab we'll describe how to do this through Azure CLI or using Bicep.

> If you are up for the challenge of doing this through Pulumi or Terraform be our guest! we would love ❤️ to see what you did so we can integrate it into these labs to make it better. PRs welcome ;) 

### 2.2 Deploying Globo Tickets using Azure CLI
todo: cli scripts to deploy infra+containers

### 2.3 Deploying Globo Tickets using Bicep

- Creating an App environment + required resources
- creating a module for deploying container apps
- deploying the application
