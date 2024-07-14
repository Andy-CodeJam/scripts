# Load environment variables
. ./Set-EnvVars.ps1

# Ensure environment variables are loaded
if (-not $env:RESOURCE_GROUP -or -not $env:LOCATION -or -not $env:COSMOS_DB__SERVICE_NAME -or -not $global:COSMOS_DB__DATABASE_NAMES) {
    Write-Error "Environment variables are not set. Please run Set-EnvVars.ps1 first."
    exit 1
}

# Create the service if it doesn't already exist
$serviceExists = az cosmosdb check-name-exists --name $env:COSMOS_DB__SERVICE_NAME
if ($serviceExists -eq $false) {
    try {
        az cosmosdb create `
            --name $env:COSMOS_DB__SERVICE_NAME `
            --resource-group $env:COSMOS_DB__RESOURCE_GROUP `
            --locations regionName=$env:COSMOS_DB__LOCATION `
                         failoverPriority=$env:COSMOS_DB__LOCATION_FAILOVER_PRIORITY `
                         isZoneRedundant=$env:COSMOS_DB__LOCATION_IS_ZONE_REDUNDANT 
        Write-Output "Cosmos DB service created."
    } catch {
        Write-Error "Failed to create Cosmos DB service: $_"
        exit 1
    }
} else {
    Write-Output "Cosmos DB service already exists. Skipping."
}

# Loop through each database name and create the database if it doesn't already exist
foreach ($databaseName in $global:COSMOS_DB__DATABASE_NAMES) {
    $dbExists = az cosmosdb sql database exists `
        --account-name $env:COSMOS_DB__SERVICE_NAME `
        --resource-group $env:COSMOS_DB__RESOURCE_GROUP `
        --name $databaseName
    
    if ($dbExists -eq $false) {
        try {
            az cosmosdb sql database create `
                --account-name $env:COSMOS_DB__SERVICE_NAME `
                --resource-group $env:COSMOS_DB__RESOURCE_GROUP `
                --name $databaseName
            Write-Output "Cosmos DB database $databaseName created."
        } catch {
            Write-Error "Failed to create Cosmos DB database $databaseName: $_"
        }
    } else {
        Write-Output "Cosmos DB database $databaseName already exists. Skipping."
    }
}

Write-Output "Cosmos DB setup complete."
