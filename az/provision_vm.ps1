# Variables
$resourceGroup = "myResourceGroup"
$location = "eastus"
$vmName = "myVM"
$image = "UbuntuLTS"
$size = "Standard_DS1_v2"
$adminUsername = "azureuser"
$sshKeyDir = "$env:USERPROFILE\.ssh"
$sshKeyName = "id_rsa_azure"
$sshKeyPath = "$sshKeyDir\$sshKeyName"

# Create SSH key if it doesn't exist
if (-Not (Test-Path -Path "$sshKeyPath")) {
    Write-Output "Generating SSH key..."
    New-Item -ItemType Directory -Force -Path $sshKeyDir | Out-Null
    ssh-keygen -t rsa -b 2048 -f $sshKeyPath -N "" | Out-Null
}

# Create a resource group
Write-Output "Creating resource group..."
az group create --name $resourceGroup --location $location | Out-Null

# Create a virtual network
Write-Output "Creating virtual network..."
az network vnet create --resource-group $resourceGroup --name myVnet --subnet-name mySubnet | Out-Null

# Create a public IP address
Write-Output "Creating public IP address..."
az network public-ip create --resource-group $resourceGroup --name myPublicIP | Out-Null

# Create a network security group
Write-Output "Creating network security group..."
az network nsg create --resource-group $resourceGroup --name myNetworkSecurityGroup | Out-Null

# Create a virtual network card and associate with public IP address and NSG
Write-Output "Creating network interface..."
az network nic create `
  --resource-group $resourceGroup `
  --name myNic `
  --vnet-name myVnet `
  --subnet mySubnet `
  --network-security-group myNetworkSecurityGroup `
  --public-ip-address myPublicIP | Out-Null

# Create a virtual machine
Write-Output "Creating virtual machine..."
az vm create `
  --resource-group $resourceGroup `
  --name $vmName `
  --location $location `
  --nics myNic `
  --image $image `
  --size $size `
  --admin-username $adminUsername `
  --ssh-key-values "$sshKeyPath.pub" `
  --authentication-type ssh | Out-Null

# Open port 22 to allow SSH traffic to host
Write-Output "Opening port 22..."
az vm open-port --port 22 --resource-group $resourceGroup --name $vmName | Out-Null

# Output the SSH connection string
$publicIp = az vm show -d -g $resourceGroup -n $vmName --query publicIps -o tsv
$sshCommand = "ssh -i `"$sshKeyPath`" $adminUsername@$publicIp"
Write-Output "VM provisioning complete. You can connect to the VM using:"
Write-Output $sshCommand

# Create alias for SSH connection
$profilePath = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

if (-Not (Test-Path -Path $profilePath)) {
    New-Item -ItemType File -Force -Path $profilePath | Out-Null
}

Add-Content -Path $profilePath -Value "`nSet-Alias -Name connectMyVM -Value `$sshCommand"

Write-Output "Alias 'connectMyVM' has been created. You can connect to the VM using the command 'connectMyVM' in a new PowerShell session."
