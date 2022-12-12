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
By default when we deploy a new revision all traffic will be sent to the newest revision. there is a property called `latestReadyRevisionName` that can be used to see if a new revision is healthy and ready to process requests. So by only adding multi revision mode we can enable zero downtime deployments.

Go set revision mode to multiple and see how your revisions work out. 

https://learn.microsoft.com/en-us/azure/container-apps/revisions-manage?tabs=bash

- Try things out like setting traffic to a specific revision.

Here is an example of how ingress with multiple revisions could work:

```yaml
{
  ...
  "configuration": {
    "ingress": {
      "traffic": [
        {
          "revisionName": <REVISION1_NAME>,
          "weight": 50
        },
        {
          "revisionName": <REVISION2_NAME>,
          "weight": 30
        },
        {
          "latestRevision": true,
          "weight": 20
        }
      ]
    }
  }
}
```

## 4. Focussed canary releases

Lets take revisions a step further to do focussed canary releases. A Canary release is a releasy that is a release that is done on production to see if the new version is working correctly by sending "some" traffic to it to see if that works.

You could do a certain % of all the traffic with the previous exercise but let's make it so that we can inspect our stuff from within a pull request.

We're going to set up the following workflow:

- every time you create a pull request or change to a pr a new revision should be created.
- The new url where no traffic is forwarded to by default is sent as a message to the pr comments
- When you merge the pr all the traffic is sent to the new revision and the old revision is disabled.

> Github workflow [docs for triggers & filters](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)

1. Create or update a new GitHub action workflow that triggers when you create a new pull request

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened, closed]
```

2. Add an action that builds new container images and sends them to the container registry

> You could add the pr git hash to the tag of the container image so you know which version belongs to which pull request.

3. Make sure that you only execute the build action on opening of a pull request. not when closed

```yaml
if: github.event_name == 'push' || (github.event_name == 'pull_request' && github.event.action != 'closed') || github.event_name == 'repository_dispatch' || github.event_name == 'workflow_dispatch'
```

4.  Deploy the newly build container image to Azure Container Apps in a GitHub action using Azure CLI.

```bash
az config set extension.use_dynamic_install=yes_without_prompt
az containerapp update \
  --resource-group globo-tickets \
  --name frontend \
  --image ${{ needs.build-container.outputs.containerImage-frontend }} \
  --revision-suffix ${{ needs.set-env.outputs.version }} \
  --output tsv \
  --query properties.latestRevisionFqdn
FQDN=$(az containerapp revision show \
  --resource-group globo-tickets \
  --name frontend \
  --revision frontend--${{ needs.set-env.outputs.version }} \
  --query "properties.fqdn" \
  --output tsv)
echo "FQDN=$FQDN" >> $GITHUB_ENV
```

5. send the new revision url `FQDN` to the pull request comments
You can use the following GitHub Action for that

```yaml
- uses: mshick/add-pr-comment@v1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    message: |
      New app revision created at: [${{ env.FQDN}}](https://${{ env.FQDN}})
```

6. when the PR is closed send all traffic to this new revision and disable the old revision

```bash
az config set extension.use_dynamic_install=yes_without_prompt
OLDREVISION=$( az containerapp revision list -n frontend -g globo-tickets --output tsv --query "[?properties.trafficWeight==\`100\`].name | [0]")
az containerapp ingress traffic set -n frontend -g globo-tickets --revision-weight latest=100
az containerapp revision deactivate -n frontend -g globo-tickets --revision $OLDREVISION
```

> Make sure that this last action is only executed during pull request close
> ```yaml
>close-pr:
>  if: github.event_name == 'pull_request' && github.event.action == 'closed'
>  runs-on: ubuntu-latest
>    name: Close Pull Request

Now that you're should be able to create a small change in your code and test it out on production in a safe way.

7. Go and make a small change by changing some text in a view somewhere and create a pull request to see it's effects.