# Load environment variables
. ./Set-EnvVars.ps1

# Ensure environment variables are loaded
if (-not $env:AKS__RESOURCE_GROUP
    -or -not $env:AKS__LOCATION
    -or -not $global:AKS__CLUSTERS) {
    Write-Error "Environment variables are not set. Please run Set-EnvVars.ps1 first."
    exit 1
}

# Create resource group if it doesn't exist
$rgExists = az group exists --name $env:AKS__RESOURCE_GROUP

if ($rgExists -eq $false) {
    try {
        az group create --name $env:AKS__RESOURCE_GROUP --location $env:AKS__LOCATION
        Write-Output "Resource group $env:AKS__RESOURCE_GROUP created."
    } catch {
        Write-Error "Failed to create resource group: $_"
        exit 1
    }
} else {
    Write-Output "Resource group $env:AKS__RESOURCE_GROUP already exists. Skipping creation."
}

# Loop through each AKS cluster configuration and create the cluster if it doesn't already exist
foreach ($aks in $global:AKS__CLUSTERS) {
    $aksName = $aks.NAME
    $nodeCount = $aks.NODE_COUNT
    $nodeSize = $aks.NODE_SIZE

    $aksExists = az aks show --name $aksName --resource-group $env:AKS__RESOURCE_GROUP --output tsv 2>$null

    if ($aksExists) {
        Write-Output "AKS Cluster $aksName already exists. Skipping creation."
    } else {
        try {
            az aks create `
                --resource-group $env:AKS__RESOURCE_GROUP `
                --name $aksName `
                --node-count $nodeCount `
                --node-vm-size $nodeSize `
                --generate-ssh-keys `
                --enable-addons monitoring `
                --enable-rbac
            Write-Output "AKS Cluster $aksName created."
        } catch {
            Write-Error "Failed to create AKS Cluster $aksName: $_"
        }

        # Get AKS credentials
        try {
            az aks get-credentials --resource-group $env:AKS__RESOURCE_GROUP --name $aksName
            Write-Output "Retrieved credentials for AKS Cluster $aksName."
        } catch {
            Write-Error "Failed to retrieve credentials for AKS Cluster $aksName: $_"
        }
    }
}

Write-Output "AKS cluster provisioning complete."
