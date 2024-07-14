# Load environment variables
. ./Set-EnvVars.ps1

# Ensure environment variables are loaded
if (-not $env:SQL_SERVER__RESOURCE_GROUP -or -not $env:SQL_SERVER__LOCATION -or -not $env:SQL_SERVER__NAME -or -not $env:SQL_SERVER__ADMIN_USERNAME -or -not $env:SQL_SERVER__ADMIN_PASSWORD -or -not $global:SQL_SERVER__DATABASE_NAME -or -not $env:SQL_SERVER__SERVICE_OBJECTIVE) {
    Write-Error "Environment variables are not set. Please run Set-EnvVars.ps1 first."
    exit 1
}

# Check if the SQL server already exists
$sqlServerExists = az sql server show --name $env:SQL_SERVER__NAME --resource-group $env:SQL_SERVER__RESOURCE_GROUP --output tsv 2>$null

if ($sqlServerExists) {
    Write-Output "SQL Server $env:SQL_SERVER__NAME already exists. Skipping creation."
} else {
    # Create the SQL server
    try {
        az sql server create `
            --name $env:SQL_SERVER__NAME `
            --resource-group $env:SQL_SERVER__RESOURCE_GROUP `
            --location $env:SQL_SERVER__LOCATION `
            --admin-user $env:SQL_SERVER__ADMIN_USERNAME `
            --admin-password $env:SQL_SERVER__ADMIN_PASSWORD
        Write-Output "SQL Server $env:SQL_SERVER__NAME created."
    } catch {
        Write-Error "Failed to create SQL Server: $_"
        exit 1
    }
}

# Loop through each database name and create the database if it doesn't already exist
foreach ($databaseName in $global:SQL_SERVER__DATABASE_NAME) {
    $sqlDbExists = az sql db show --name $databaseName --server $env:SQL_SERVER__NAME --resource-group $env:SQL_SERVER__RESOURCE_GROUP --output tsv 2>$null
    
    if ($sqlDbExists) {
        Write-Output "SQL Database $databaseName already exists. Skipping creation."
    } else {
        try {
            az sql db create `
                --resource-group $env:SQL_SERVER__RESOURCE_GROUP `
                --server $env:SQL_SERVER__NAME `
                --name $databaseName `
                --service-objective $env:SQL_SERVER__SERVICE_OBJECTIVE
            Write-Output "SQL Database $databaseName created."
        } catch {
            Write-Error "Failed to create SQL Database $databaseName: $_"
        }
    }
}

Write-Output "SQL Server and Database setup complete."
