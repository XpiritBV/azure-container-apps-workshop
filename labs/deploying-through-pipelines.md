# Lab 3: Automating Container app deployments

## 1. Deploying full infrastructure using Github Actions

> Single revision mode is the default mode when deploying Azure Container Apps. At first we'll keep it this way and this means which each deployment a new version will overwrite the existing running container. This will result in a few seconds downtime.In the next assignment we'll take care of that.

To deploy a container app we first need to create the infrastructure like the Container App environment first. You can do this by creating a github action that will deploy all infrastructure.

The nice thing of infrastructure as code is that it is "idempotent". This means we can do this over and over again and that shouldn't fail.

1.  If you haven't already fork this repo to your own account so you have access to the github actions.
2. Add the infrastructure as code scripts you created in Lab 2 to a folder called `infra`.
2. Create a github workflow that will trigger on changes in the `infra` folder and add an action to deploy bicep or azure cli scripts.

> Tips on [triggering github actions](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)

> take a look at the current [github actions workflow](https://github.com/XpiritBV/azure-container-apps-workshop/blob/main/.github/workflows/build-containers.yml) that builds the container images

> [Azure CLI Deploy action](https://github.com/marketplace/actions/azure-cli-action) you could use in your Github actions workflow.

You can use the Azure CLI Action to deploy bicep files like below.

```yaml
- name: Deploy bicep
uses: azure/CLI@v1
with:
    inlineScript: |
    az deployment group create -g "globo-tickets" -f ./infra/main.bicep \
        -p \
        frontendImage='' \
        catalogImage='' \
        orderingImage='' \
        containerRegistry=${{ env.REGISTRY }} \
        containerRegistryUsername=${{ github.actor }} \
        containerRegistryPassword=${{ secrets.GITHUB_TOKEN }} \
        appName='globotickets' \
```

> Tip: Using [GitHub secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) to store secrets.

> Tip2: If you want to link to the existing Globo Tickets containers you don't need a username + password since these are public images.

## 2. Exploring Revisions
Azure Container apps has a feature called "Multi revision mode". This means for a single container app you can have multiple active revisions at the same time. 

We'll be working with setting the `Frontend` app to multi revision mode so we can easily see changes on the website.

You can set multi revision mode in Bicep using the `activeRevisionsMode` property.

To do this we first need to build the container images. Let's create a new github action that triggers on all changes in the `src/globo-tickets-basic/frontend/` folder.

- Build & publish the container images to a container registry

First login to your container registry
```yaml
- name: Log into registry ${{ env.REGISTRY }}
        uses: docker/login-action@v1
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN}}
```

After that build & publish the image to the GitHub container registry

```yaml
 - name: Build and push Docker image
        uses: docker/build-push-action@v2
        with:
          file: "src/globo-tickets-basic/frontend/Dockerfile"
          push: true
```

## 3. Zero downtime Deployments
healthchecks + readiness probes

## 4. Canary releases
pr workflow with revisions