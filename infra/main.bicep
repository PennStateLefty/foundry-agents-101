targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment (used for resource naming)')
param environmentName string

@description('Primary Azure region for resources')
param location string

var tags = {
  'azd-env-name': environmentName
}

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module appService 'modules/app-service.bicep' = {
  name: 'app-service'
  scope: resourceGroup
  params: {
    appServicePlanName: 'plan-${resourceToken}'
    webAppName: 'app-${resourceToken}'
    location: location
    tags: tags
  }
}

module foundry 'modules/foundry.bicep' = {
  name: 'foundry'
  scope: resourceGroup
  params: {
    foundryName: 'foundry-${resourceToken}'
    location: location
    tags: tags
  }
}

module bingGrounding 'modules/bing-grounding.bicep' = {
  name: 'bing-grounding'
  scope: resourceGroup
  params: {
    bingName: 'bing-${resourceToken}'
    tags: tags
  }
}

output AZURE_RESOURCE_GROUP string = resourceGroup.name
output AZURE_WEBAPP_NAME string = appService.outputs.webAppName
output AZURE_WEBAPP_URL string = appService.outputs.webAppUrl
output AZURE_FOUNDRY_NAME string = foundry.outputs.foundryName
output AZURE_FOUNDRY_ENDPOINT string = foundry.outputs.foundryEndpoint
output AZURE_BING_NAME string = bingGrounding.outputs.bingName
