$vnetName = "myVNet"
$subnetName = "mySubnet"

az network vnet create `
  --resource-group $resourceGroup `
  --name $vnetName `
  --address-prefix 10.0.0.0/16 `
  --subnet-name $subnetName `
  --subnet-prefix 10.0.0.0/24
