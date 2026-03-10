targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment (used for resource naming)')
param environmentName string

@description('Primary Azure region for resources')
param location string

@minLength(1)
@maxLength(90)
@description('Name of the Azure resource group')
param resourceGroupName string

var tags = {
  'azd-env-name': environmentName
}

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
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
    accountName: 'foundry-${resourceToken}'
    projectName: 'agents-lab'
    location: location
    tags: tags
  }
}

module bingGrounding 'modules/bing-grounding.bicep' = {
  name: 'bing-grounding'
  scope: resourceGroup
  params: {
    bingName: 'bing-${resourceToken}'
    foundryName: foundry.outputs.accountName
    tags: tags
  }
}

module roleAssignments 'modules/role-assignments.bicep' = {
  name: 'role-assignments'
  scope: resourceGroup
  params: {
    principalId: appService.outputs.webAppPrincipalId
    foundryId: foundry.outputs.accountId
  }
}

output AZURE_RESOURCE_GROUP string = resourceGroup.name
output AZURE_WEBAPP_NAME string = appService.outputs.webAppName
output AZURE_WEBAPP_URL string = appService.outputs.webAppUrl
output AZURE_FOUNDRY_NAME string = foundry.outputs.accountName
output AZURE_FOUNDRY_ENDPOINT string = foundry.outputs.accountEndpoint
output AZURE_BING_NAME string = bingGrounding.outputs.bingName
