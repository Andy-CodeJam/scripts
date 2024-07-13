$sqlServerName = "mySqlServer"
$adminUser = "myadmin"
$adminPassword = "mypassword"
$databaseName = "mySampleDatabase"

az sql server create `
  --name $sqlServerName `
  --resource-group $resourceGroup `
  --location $location `
  --admin-user $adminUser `
  --admin-password $adminPassword

az sql db create `
  --resource-group $resourceGroup `
  --server $sqlServerName `
  --name $databaseName `
  --service-objective S0
