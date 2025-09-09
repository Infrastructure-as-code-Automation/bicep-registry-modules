#!/bin/bash

set -e  # Exit on any error

exec >/dev/null 2>&1 # Redirect log to avoid ACI issue

echo "Starting Marketplace Gallery Image deployment script..."

# Check required environment variables
if [ -z "$RESOURCE_GROUP_NAME" ] || [ -z "$SUBSCRIPTION_ID" ] || [ -z "$IMAGE_NAME" ] || [ -z "$IMAGE_LOCATION" ] || [ -z "$CUSTOM_LOCATION_RESOURCE_ID" ] || [ -z "$IMAGE_OS_TYPE" ] || [ -z "$IMAGE_PUBLISHER" ] || [ -z "$IMAGE_OFFER" ] || [ -z "$IMAGE_SKU" ] || [ -z "$IMAGE_HYPER_V_GENERATION" ] || [ -z "$IMAGE_CLOUD_INIT_DATA_SOURCE" ] || [ -z "$IMAGE_CONTAINER_RESOURCE_ID" ] || [ -z "$IMAGE_VERSION_NAME" ] || [ -z "$MARKETPLACE_GALLERY_IMAGE_BICEP_BASE64" ]; then
    echo "Error: Required environment variables are missing"
    exit 1
fi

# Set subscription context
echo "Setting subscription context to: $SUBSCRIPTION_ID"
az account set --subscription "$SUBSCRIPTION_ID"

# Create directory structure and decode base64 files
echo "Creating required directory structure and bicep files..."

# Create nested directory
mkdir -p nested

# Decode and create marketplace-gallery-image.bicep file
echo "Creating marketplace-gallery-image.bicep file from base64 encoded content..."
echo "$MARKETPLACE_GALLERY_IMAGE_BICEP_BASE64" | base64 -d > nested/marketplace-gallery-image.bicep

# Verify the files were created successfully
if [ ! -f "nested/marketplace-gallery-image.bicep" ] || [ ! -s "nested/marketplace-gallery-image.bicep" ]; then
    echo "Error: Failed to create nested/marketplace-gallery-image.bicep file or file is empty"
    exit 1
fi

echo "✅ All bicep files created successfully"
echo "nested/marketplace-gallery-image.bicep size: $(wc -c < nested/marketplace-gallery-image.bicep) bytes"

# List current directory structure for debugging
echo "Current directory structure:"
find . -name "*.bicep" -type f

# Create parameter file for deployment
PARAM_FILE="deployment-params.json"

# Create a proper parameter file with JSON object
echo "Creating parameter file..."
cat > "$PARAM_FILE" << EOF
{
  "\$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": $IMAGE_NAME
    },
    "location": {
      "value": $IMAGE_LOCATION
    },
    "customLocationResourceId": {
      "value": $CUSTOM_LOCATION_RESOURCE_ID
    },
    "osType": {
      "value": "$IMAGE_OS_TYPE"
    },
    "publisher": {
      "value": "$IMAGE_PUBLISHER"
    },
    "offer": {
      "value": "$IMAGE_OFFER"
    },
    "sku": {
      "value": "$IMAGE_SKU"
    },
    "hyperVGeneration": {
      "value": $IMAGE_HYPER_V_GENERATION
    },
    "cloudInitDataSource": {
      "value": $IMAGE_CLOUD_INIT_DATA_SOURCE
    },
    "containerResourceId": {
      "value": $IMAGE_CONTAINER_RESOURCE_ID
    },
    "versionName": {
      "value": $IMAGE_VERSION_NAME
    }
  }
}
EOF

# Validate the parameter file
echo "Validating parameter file..."
if ! jq empty "$PARAM_FILE" 2>/dev/null; then
    echo "Error: Generated parameter file is not valid JSON"
    cat "$PARAM_FILE"
    exit 1
fi

echo "✅ Parameter file created and validated successfully"

# Print parameter file content for debugging
echo "============================================"
echo "Parameter file content:"
echo "============================================"
cat "$PARAM_FILE" | jq '.'
echo "============================================"

# Check if marketplace gallery image resource exists
echo "Checking if marketplace gallery image resource already exists..."

# Construct the resource ID for marketplace gallery image
MARKETPLACE_GALLERY_IMAGE_RESOURCE_ID="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/microsoft.azurestackhci/marketplaceGalleryImages/$IMAGE_NAME"

echo "Checking resource: $MARKETPLACE_GALLERY_IMAGE_RESOURCE_ID"

# Check if the marketplace gallery image resource exists
# Redirect both stdout and stderr to suppress all output, only check exit code
if az resource show --ids "$MARKETPLACE_GALLERY_IMAGE_RESOURCE_ID" >/dev/null 2>&1; then
    echo "✅ Marketplace gallery image resource already exists. Checking status..."

    # Get the provisioning state and deployment mode
    PROVISIONING_STATE=$(az resource show --ids "$MARKETPLACE_GALLERY_IMAGE_RESOURCE_ID" --query "properties.provisioningState" --output tsv 2>/dev/null)

    echo "Resource ID: $MARKETPLACE_GALLERY_IMAGE_RESOURCE_ID"
    echo "Provisioning State: $PROVISIONING_STATE"

    if [ "$PROVISIONING_STATE" = "Succeeded" ]; then
        echo "✅ Deployment resource is in successful state. Skipping deployment."
        exit 0
    else
        echo "❌ Deployment resource exists but is not in successful state!"
        echo "Expected: Succeeded, Actual: $PROVISIONING_STATE"

        # Show resource details for debugging
        echo "Resource details:"
        az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --query "{name: name, provisioningState: properties.provisioningState, deploymentMode: properties.deploymentMode}" --output table 2>/dev/null || echo "Could not retrieve resource details"

        exit 1
    fi
else
    echo "📝 Marketplace gallery image resource does not exist. Proceeding with deployment..."
fi

# Execute Bicep deployment
DEPLOYMENT_NAME="image-deployment-$(date +%s)"

echo "Starting deployment: $DEPLOYMENT_NAME"
echo "Using template: nested/marketplace-gallery-image.bicep"
echo "Using parameter file: $PARAM_FILE"

# Check if nested/marketplace-gallery-image.bicep file was created successfully
if [ ! -f "nested/marketplace-gallery-image.bicep" ]; then
    echo "Error: nested/marketplace-gallery-image.bicep file was not created successfully"
    echo "Current directory contents:"
    ls -la
    exit 1
fi

echo "✅ nested/marketplace-gallery-image.bicep file found and ready for deployment"

# Execute deployment with parameter file
az deployment group create \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --name "$DEPLOYMENT_NAME" \
    --template-file "nested/marketplace-gallery-image.bicep" \
    --parameters "@$PARAM_FILE" \
    --verbose

DEPLOYMENT_STATUS=$?

if [ $DEPLOYMENT_STATUS -eq 0 ]; then
    echo "✅ Deployment completed successfully"

    # Get deployment outputs
    echo "Deployment outputs:"
    az deployment group show \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$DEPLOYMENT_NAME" \
        --query "properties.outputs" \
        --output table
else
    echo "❌ Deployment failed with status: $DEPLOYMENT_STATUS"

    # Get deployment error details
    echo "Deployment error details:"
    az deployment group show \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$DEPLOYMENT_NAME" \
        --query "properties.error" \
        --output json

    # Also show the deployment operations for more details
    echo "Deployment operations:"
    az deployment operation group list \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$DEPLOYMENT_NAME" \
        --query "[?properties.provisioningState=='Failed'].{operation: operationId, code: properties.statusCode, message: properties.statusMessage}" \
        --output table

    exit $DEPLOYMENT_STATUS
fi

# Clean up temporary files
rm -f "$PARAM_FILE"
rm -f "nested/marketplace-gallery-image.bicep"

echo "Completed deployment"

echo "🎉 HCI deployment completed successfully!"

# Set output for Bicep usage
cat > $AZ_SCRIPTS_OUTPUT_PATH << EOF
{
  "status": "success",
  "message": "Deployment completed successfully",
}
EOF
