$functionAppName = "myFunctionApp"
$storageAccountName = "mystorageaccount"

az functionapp create `
  --resource-group $resourceGroup `
  --consumption-plan-location $location `
  --runtime python `
  --functions-version 3 `
  --name $functionAppName `
  --storage-account $storageAccountName
