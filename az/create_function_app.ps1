# Load environment variables
. ./Set-EnvVars.ps1

# Ensure environment variables are loaded
if (-not $env:FUNCTION_APPS__RESOURCE_GROUP
    -or -not $env:FUNCTION_APPS__LOCATION
    -or -not $env:STORAGE_ACCOUNT__NAME
    -or -not $global:FUNCTION_APPS) {
    Write-Error "Environment variables are not set. Please run Set-EnvVars.ps1 first."
    exit 1
}

# Create resource group if it doesn't exist
$rgExists = az group exists --name $env:FUNCTION_APPS__RESOURCE_GROUP

if ($rgExists -eq $false) {
    try {
        az group create
          --name $env:FUNCTION_APPS__RESOURCE_GROUP
          --location $env:FUNCTION_APPS__LOCATION
        Write-Output "Resource group $env:FUNCTION_APPS__RESOURCE_GROUP created."
    } catch {
        Write-Error "Failed to create resource group: $_"
        exit 1
    }
} else {
    Write-Output "Resource group $env:FUNCTION_APPS__RESOURCE_GROUP already exists. Skipping creation."
}

# Create storage account if it doesn't exist
$storageAccountExists = (
  az storage account check-name
    --name $env:STORAGE_ACCOUNT__NAME
    --query "nameAvailable"
    --output tsv
)

if ($storageAccountExists -eq $false) {
    Write-Output "Storage account $env:STORAGE_ACCOUNT__NAME already exists. Skipping creation."
} else {
    try {
        az storage account create `
            --name $env:STORAGE_ACCOUNT__NAME `
            --resource-group $env:FUNCTION_APPS__RESOURCE_GROUP `
            --location $env:FUNCTION_APPS__LOCATION `
            --sku $env:STORAGE_ACCOUNT__SKU
        Write-Output "Storage account $env:STORAGE_ACCOUNT__NAME created."
    } catch {
        Write-Error "Failed to create storage account: $_"
        exit 1
    }
}

# Loop through each Function App configuration and create the Function App if it doesn't already exist
foreach ($functionApp in $global:FUNCTION_APPS) {
    $functionAppName = $functionApp.NAME
    $runtime = $functionApp.RUNTIME
    $version = $functionApp.VERSION

    $functionAppExists = az functionapp show --name $functionAppName --resource-group $env:FUNCTION_APPS__RESOURCE_GROUP --output tsv 2>$null

    if ($functionAppExists) {
        Write-Output "Function App $functionAppName already exists. Skipping creation."
    } else {
        try {
            az functionapp create `
                --resource-group $env:FUNCTION_APPS__RESOURCE_GROUP `
                --consumption-plan-location $env:FUNCTION_APPS__LOCATION `
                --runtime $runtime `
                --runtime-version $version `
                --name $functionAppName `
                --storage-account $env:STORAGE_ACCOUNT__NAME
            Write-Output "Function App $functionAppName created."
        } catch {
            Write-Error "Failed to create Function App $functionAppName: $_"
        }
    }
}

Write-Output "Function App provisioning complete."
