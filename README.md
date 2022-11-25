# azure-container-apps-workshop
Workshop for learning to use Azure Container Apps


# Table of Contents

1. Hello world (using Azure portal)
  - 1 app environment, 1 demo app
2. Infra structure as code (cli + bicep)
  - globo ticket app (3 containers)
  - ingress external + internal
  - app environment + log analytics
  - local execution of bicep + cli
3. Deploying it through pipeline (Revisions)
  - github action building the code + deploying it to aca
  - secrets
  - health checks / readiness probes
  - pr workflow with revisions
5. Observability
  - log streams in portal
  - cli see output container
  - cli interactive into container
6. Using Dapr
  - app insights instrumentation key -> application map
  - dapr config
    - state store
    - pubsub
    - secret store
7. Scaling with Keda
  - pubsub



