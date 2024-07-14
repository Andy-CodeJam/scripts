# Load environment variables
. ./Set-EnvVars.ps1

# Ensure environment variables are loaded
if (-not $env:APP_SERVICE__RESOURCE_GROUP
    -or -not $env:APP_SERVICE__LOCATION
    -or -not $env:APP_SERVICE__PLAN_NAME
    -or -not $env:APP_SERVICE__SKU
    -or -not $global:WEB_APPS) {
    Write-Error "Environment variables are not set. Please run Set-EnvVars.ps1 first."
    exit 1
}

# Create resource group if it doesn't exist
$rgExists = az group exists --name $env:APP_SERVICE__RESOURCE_GROUP

if ($rgExists -eq $false) {
    try {
        az group create `
          --name $env:APP_SERVICE__RESOURCE_GROUP `
          --location $env:APP_SERVICE__LOCATION
        Write-Output "Resource group $env:APP_SERVICE__RESOURCE_GROUP created."
    } catch {
        Write-Error "Failed to create resource group: $_"
        exit 1
    }
} else {
    Write-Output "Resource group $env:APP_SERVICE__RESOURCE_GROUP already exists. Skipping creation."
}

# Create App Service Plan if it doesn't exist
$appServicePlanExists = az appservice plan show --name $env:APP_SERVICE__PLAN_NAME --resource-group $env:APP_SERVICE__RESOURCE_GROUP --output tsv 2>$null

if ($appServicePlanExists) {
    Write-Output "App Service Plan $env:APP_SERVICE__PLAN_NAME already exists. Skipping creation."
} else {
    try {
        az appservice plan create `
            --name $env:APP_SERVICE__PLAN_NAME `
            --resource-group $env:APP_SERVICE__RESOURCE_GROUP `
            --location $env:APP_SERVICE__LOCATION `
            --sku $env:APP_SERVICE__SKU `
            --is-linux
        Write-Output "App Service Plan $env:APP_SERVICE__PLAN_NAME created."
    } catch {
        Write-Error "Failed to create App Service Plan: $_"
        exit 1
    }
}

# Loop through each Web App configuration and create the Web App if it doesn't already exist
foreach ($webApp in $global:WEB_APPS) {
    $webAppName = $webApp.NAME
    $runtime = $webApp.RUNTIME

    $webAppExists = az webapp show --name $webAppName --resource-group $env:APP_SERVICE__RESOURCE_GROUP --output tsv 2>$null

    if ($webAppExists) {
        Write-Output "Web App $webAppName already exists. Skipping creation."
    } else {
        try {
            az webapp create `
                --resource-group $env:APP_SERVICE__RESOURCE_GROUP `
                --plan $env:APP_SERVICE__PLAN_NAME `
                --name $webAppName `
                --runtime $runtime
            Write-Output "Web App $webAppName created."
        } catch {
            Write-Error "Failed to create Web App $webAppName: $_"
        }
    }
}

Write-Output "App Service and Web App provisioning complete."
