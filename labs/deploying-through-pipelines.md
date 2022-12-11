# Lab 3: Automating Container app deployments

## 1. Deploying full infrastructure using Github Actions

> Single revision mode is the default mode when deploying Azure Container Apps. At first we'll keep it this way and this means which each deployment a new version will overwrite the existing running container. This will result in a few seconds downtime.In the next assignment we'll take care of that.

To deploy a container app we first need to create the infrastructure like the Container App environment first. You can do this by creating a github action that will deploy all infrastructure.

The nice thing of infrastructure as code is that it is "idempotent". This means we can do this over and over again and that shouldn't fail.

1.  If you haven't already fork this repo to your own account so you have access to the github actions.
2. Add the infrastructure as code scripts you created in Lab 2 to a folder called `infra`.
2. Create a github workflow that will trigger on changes in the `infra` folder and add an action to deploy bicep or azure cli scripts.

> Tips on triggering github actions TODO

> Azure Deploy action you could use in your Github actions workflow. TODO

## 2. Exploring Revisions
multi revision mode

## 3. Zero downtime Deployments
healthchecks + readiness probes

## 4. Canary releases
pr workflow with revisions