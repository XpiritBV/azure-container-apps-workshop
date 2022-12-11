FRONTEND_IMAGE="ghcr.io/xpiritbv/azure-container-apps-workshop/frontend-dapr"
CATALOG_IMAGE="ghcr.io/xpiritbv/azure-container-apps-workshop/catalog-dapr"
ORDERING_IMAGE="ghcr.io/xpiritbv/azure-container-apps-workshop/ordering-dapr"
REGISTRY_NAME="ghcr.io"

az deployment group create -g "globo-tickets" -f ./infra/main.bicep \
    -p \
    frontendImage=$FRONTEND_IMAGE \
    catalogImage=$CATALOG_IMAGE \
    orderingImage=$ORDERING_IMAGE \
    containerRegistry=$REGISTRY_NAME \
    appName='globotickets-reinier' \