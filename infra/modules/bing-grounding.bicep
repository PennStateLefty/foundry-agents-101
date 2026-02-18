@description('Name of the Grounding with Bing resource')
param bingName string

@description('Tags to apply to resources')
param tags object = {}

resource bingGrounding 'Microsoft.Bing/accounts@2025-05-01-preview' = {
  name: bingName
  tags: tags
  kind: 'Bing.Grounding'
  sku: {
    name: 'G1'
  }
  properties: {}
}

output bingName string = bingGrounding.name
output bingId string = bingGrounding.id
