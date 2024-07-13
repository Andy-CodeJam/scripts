$appServicePlan = "myAppServicePlan"
$webAppName = "myWebApp"
$runtime = "PYTHON|3.8"

az appservice plan create `
  --name $appServicePlan `
  --resource-group $resourceGroup `
  --sku B1 `
  --is-linux

az webapp create `
  --resource-group $resourceGroup `
  --plan $appServicePlan `
  --name $webAppName `
  --runtime $runtime
