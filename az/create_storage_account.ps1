# Load environment variables
. ./Set-EnvVars.ps1

# Ensure environment variables are loaded
if (-not $env:STORAGE_ACCOUNT__NAME -or -not $env:STORAGE_ACCOUNT__RESOURCE_GROUP -or -not $env:STORAGE_ACCOUNT__LOCATION -or -not $env:STORAGE_ACCOUNT__SKU) {
    Write-Error "Environment variables are not set. Please run Set-EnvVars.ps1 first."
    exit 1
}

# Check if the storage account already exists
$storageAccountExists = az storage account check-name --name $env:STORAGE_ACCOUNT__NAME --query "nameAvailable" --output tsv

if ($storageAccountExists -eq "false") {
    Write-Output "Storage account $env:STORAGE_ACCOUNT__NAME already exists. Skipping creation."
} else {
    # Create the storage account
    try {
        az storage account create `
            --name $env:STORAGE_ACCOUNT__NAME `
            --resource-group $env:STORAGE_ACCOUNT__RESOURCE_GROUP `
            --location $env:STORAGE_ACCOUNT__LOCATION `
            --sku $env:STORAGE_ACCOUNT__SKU
        Write-Output "Storage account $env:STORAGE_ACCOUNT__NAME created."
    } catch {
        Write-Error "Failed to create storage account: $_"
        exit 1
    }
}

Write-Output "Storage account setup complete."
