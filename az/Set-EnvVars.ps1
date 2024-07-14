# Global Environment Variables
$env:RESOURCE_GROUP = "codejam-24"
$env:LOCATION = "eastus"

# Service Environment Variables

# App Service
$env:APP_SERVICE__RESOURCE_GROUP = $env:RESOURCE_GROUP
$env:APP_SERVICE__LOCATION = $env:LOCATION
$env:APP_SERVICE__PLAN_NAME = "AppServicePlan"
$env:APP_SERVICE__SKU = "F1"
$env:APP_SERVICE__NAME = "AppServiceService"
$global:WEB_APPS = @(
    @{
        NAME = "WebApp1"
        RUNTIME = "PYTHON|3.8"
    },
    @{
        NAME = "WebApp2"
        RUNTIME = "NODE|14-lts"
    }
)

# CosmosDB
$env:COSMOS_DB__RESOURCE_GROUP = $env:RESOURCE_GROUP
$env:COSMOS_DB__LOCATION = $env:LOCATION
$env:COSMOS_DB__LOCATION_FAILOVER_PRIORITY = 0
$env:COSMOS_DB__LOCATION_IS_ZONE_REDUNDANT = $false
$env:COSMOS_DB__SERVICE_NAME = "CosmosDBService"
$global:COSMOS_DB__DATABASE_NAMES = @("cosmosdb1", "cosmosdb2", "cosmosdb3")

# SQL Server
$env:SQL_SERVER__RESOURCE_GROUP = $env:RESOURCE_GROUP
$env:SQL_SERVER__LOCATION = $env:LOCATION
$env:SQL_SERVER__NAME = "SqlServerService"
$env:SQL_SERVER__ADMIN_USERNAME = "sqladmin"
$env:SQL_SERVER__ADMIN_PASSWORD = "AQualitySecurePassword123"
$global:SQL_SERVER__DATABASE_NAME = @("sqldb")
$env:SQL_SERVER__SERVICE_OBJECTIVE = "S0"

# App Insights
$env:APP_INSIGHTS__RESOURCE_GROUP = $env:RESOURCE_GROUP
$env:APP_INSIGHTS__LOCATION = $env:LOCATION
$env:APP_INSIGHTS__NAME = "AppInsightsService"

# Storage Account
$env:STORAGE_ACCOUNT__RESOURCE_GROUP = $env:RESOURCE_GROUP
$env:STORAGE_ACCOUNT__LOCATION = $env:LOCATION
$env:STORAGE_ACCOUNT__NAME = "StorageAccountService"
$env:STORAGE_ACCOUNT__SKU = "Standard_LRS"
$env:STORAGE_ACCOUNT__KIND = "StorageV2"
$env:STORAGE_ACCOUNT__ACCESS_TIER = "Hot"

# Key Vault
$env:KEY_VAULT__RESOURCE_GROUP = $env:RESOURCE_GROUP
$env:KEY_VAULT__LOCATION = $env:LOCATION
$env:KEY_VAULT__NAME = "KeyVaultService"
$env:KEY_VAULT__SKU = "standard"
$env:KEY_VAULT__ENABLE_SOFT_DELETE = $true
$env:KEY_VAULT__ENABLE_PURGE_PROTECTION = $true
$env:KEY_VAULT__ENABLE_RBAC_AUTHORIZATION = $true
$env:KEY_VAULT__ENABLE_VNET = $true
$env:KEY_VAULT__ENABLE_VNET_SERVICE_ENDPOINT = $true
$env:KEY_VAULT__ENABLE_VNET_FIREWALL = $true
$env:KEY_VAULT__ENABLE_VNET_FIREWALL_BYPASS = "AzureServices"
$env:KEY_VAULT__ENABLE_VNET_FIREWALL_DEFAULT_ACTION = "Deny"

# Virtual Machines
$env:VIRTUAL_MACHINES__RESOURCE_GROUP = $env:RESOURCE_GROUP
$env:VIRTUAL_MACHINES__LOCATION = $env:LOCATION
$global:VIRTUAL_MACHINES = @(
    @{
        NAME = "aweaver"
        SIZE = "Standard_DS1_v2"
        IMAGE = "UbuntuLTS"
        ADMIN_USERNAME = "aweaver"
    },
    @{
        NAME = "anotheruser"
        SIZE = "Standard_B1s"
        IMAGE = "UbuntuLTS"
        ADMIN_USERNAME = "anotheruser"
    }
)

# Azure Kubernetes Service
$env:AKS__RESOURCE_GROUP = $env:RESOURCE_GROUP
$env:AKS__LOCATION = $env:LOCATION
$global:AKS__CLUSTERS = @(
    @{
        NAME = "aks-cluster--$env:AKS__RESOURCE_GROUP-$env:AKS__LOCATION-1"
        NODE_COUNT = 1
        NODE_SIZE = "Standard_DS2_v2"
    },
    @{
        NAME = "aks-cluster--$env:AKS__RESOURCE_GROUP-$env:AKS__LOCATION-2"
        NODE_COUNT = 2
        NODE_SIZE = "Standard_B2s"
    }
)

# Azure Functions
$env:FUNCTION_APPS__RESOURCE_GROUP = $env:RESOURCE_GROUP
$env:FUNCTION_APPS__LOCATION = $env:LOCATION
$global:FUNCTION_APPS = @(
    @{
        NAME = "FunctionApp1"
        RUNTIME = "python"
        VERSION = "3.9"
    },
    @{
        NAME = "FunctionApp2"
        RUNTIME = "node"
        VERSION = "14"
    }
)

Write-Output "Environment variables set."
