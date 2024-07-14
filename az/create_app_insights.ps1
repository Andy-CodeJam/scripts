# Load environment variables
. ./Set-EnvVars.ps1

# Ensure environment variables are loaded
if (-not $env:APP_INSIGHTS__NAME -or -not $env:APP_INSIGHTS__LOCATION -or -not $env:APP_INSIGHTS__RESOURCE_GROUP) {
    Write-Error "Environment variables are not set. Please run Set-EnvVars.ps1 first."
    exit 1
}

# Check if the Application Insights component already exists
$appInsightsExists = az monitor app-insights component show `
  --app $env:APP_INSIGHTS__NAME `
  --resource-group $env:APP_INSIGHTS__RESOURCE_GROUP `
  --query "instrumentationKey" `
  --output tsv 2>$null

if ($appInsightsExists) {
    Write-Output "Application Insights component already exists. Skipping creation."
    $instrumentationKey = $appInsightsExists
} else {
    # Create an Application Insights component
    try {
        az monitor app-insights component create `
          --app $env:APP_INSIGHTS__NAME `
          --location $env:APP_INSIGHTS__LOCATION `
          --resource-group $env:APP_INSIGHTS__RESOURCE_GROUP
        Write-Output "Application Insights component created."
    } catch {
        Write-Error "Failed to create Application Insights component: $_"
        exit 1
    }

    # Get the instrumentation key
    try {
        $instrumentationKey = az monitor app-insights component show `
          --app $env:APP_INSIGHTS__NAME `
          --resource-group $env:APP_INSIGHTS__RESOURCE_GROUP `
          --query "instrumentationKey" `
          --output tsv
        Write-Output "Retrieved instrumentation key."
    } catch {
        Write-Error "Failed to retrieve instrumentation key: $_"
        exit 1
    }
}

# Set the instrumentation key as an environment variable
$env:APP_INSIGHTS__INSTRUMENTATION_KEY = $instrumentationKey
Write-Output "Application Insights setup complete. Instrumentation Key: $instrumentationKey"
