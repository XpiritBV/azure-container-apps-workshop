# Azure Container Apps Workshop
Hands-on workshop in building applications hosted on Azure Container Apps.

## Preparation for the workshop
To get the best experience with the hands-on-labs it is recommended that you prepare the following ahead of time:

- A computer PC / Mac for development, capable of running containers.
- A recent version of Visual Studio Code ([download here](https://code.visualstudio.com/download)) with the Bicep extension ([download here](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep))
- Instead of Visual Studio Code it's also fine to just use Visual Studio. This will make starting/debugging the Globo Tickets app easier when you get to the Dapr part. There is a [Bicep extension for Visual Studio](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.visualstudiobicep) as wellDap
- Docker Desktop, on Windows or Mac ([download here](https://www.docker.com/products/docker-desktop))
- An Azure subscription, to create and use a container cluster and registry ([trial account here](https://azure.microsoft.com/en-us/free/))
- The Azure CLI ([download here](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli))

## Labs in this workshop

- [Lab 1 - My first container app](labs/first-container-app.md)
- [Lab 2 - Infrastructure as Code](labs/infrastructure-as-code.md)
- [Lab 3 - Automating Container app deployments](labs/deploying-through-pipelines.md)
- [Lab 4 - Observability](labs/observability.md)
- [Lab 5 - Using Dapr locally and changes to Globotickets](labs/using-dapr-locally.md)
- [Lab 6 - Using Dapr in Azure Container Apps](labs/using-dapr-aca.md)
- [Lab 7 - Scaling with KEDA](labs/scaling-with-keda.md)

## Additional Docs & Resources for Azure Container Apps

- [Microsoft Docs](https://learn.microsoft.com/en-us/azure/container-apps/)
- [Azure Container Apps Discord channel](https://aka.ms/containerapps-discord)
- [Azure Container Apps Github page](https://github.com/microsoft/azure-container-apps)