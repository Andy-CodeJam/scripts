$aksClusterName = "myAKSCluster"

az aks create `
  --resource-group $resourceGroup `
  --name $aksClusterName `
  --node-count 1 `
  --enable-addons monitoring `
  --generate-ssh-keys

az aks get-credentials `
  --resource-group $resourceGroup `
  --name $aksClusterName
