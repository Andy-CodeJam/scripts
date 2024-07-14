# Load environment variables
. ./Set-EnvVars.ps1

# Ensure environment variables are loaded
if (-not $env:VIRTUAL_MACHINES__RESOURCE_GROUP `
    -or -not $env:VIRTUAL_MACHINES__LOCATION `
    -or -not $global:VIRTUAL_MACHINES) {
      Write-Error "Environment variables are not set. Please run Set-EnvVars.ps1 first."
    exit 1
}

# Create resource group if it doesn't exist
$rgExists = az group exists --name $env:VIRTUAL_MACHINES__RESOURCE_GROUP

if ($rgExists -eq $false) {
    try {
        az group create `
          --name $env:VIRTUAL_MACHINES__RESOURCE_GROUP `
          --location $env:VIRTUAL_MACHINES__LOCATION
        Write-Output "Resource group $env:VIRTUAL_MACHINES__RESOURCE_GROUP created."
    } catch {
        Write-Error "Failed to create resource group: $_"
        exit 1
    }
} else {
    Write-Output "Resource group $env:VIRTUAL_MACHINES__RESOURCE_GROUP already exists. Skipping creation."
}

# Loop through each VM configuration and create the VM if it doesn't already exist
foreach ($vm in $global:VIRTUAL_MACHINES) {
    $vmName = $vm.NAME
    $vmSize = $vm.SIZE
    $vmImage = $vm.IMAGE
    $adminUsername = $vm.ADMIN_USERNAME
    $adminPassword = "AQualitySecurePassword123!" # Ensure to replace or manage this securely

    $vmExists = az vm show --name $vmName --resource-group $env:VIRTUAL_MACHINES__RESOURCE_GROUP --output tsv 2>$null

    if ($vmExists) {
        Write-Output "VM $vmName already exists. Skipping creation."
    } else {
        try {
            az vm create `
                --resource-group $env:VIRTUAL_MACHINES__RESOURCE_GROUP `
                --name $vmName `
                --image $vmImage `
                --size $vmSize `
                --admin-username $adminUsername `
                --admin-password $adminPassword
            Write-Output "VM $vmName created."
        } catch {
            Write-Error "Failed to create VM $vmName: $_"
        }

        # Open port 22 for SSH traffic
        try {
            az vm open-port --port 22 --resource-group $env:VIRTUAL_MACHINES__RESOURCE_GROUP --name $vmName
            Write-Output "Opened port 22 for VM $vmName."
        } catch {
            Write-Error "Failed to open port 22 for VM $vmName: $_"
        }
    }
}

Write-Output "VM provisioning complete."
