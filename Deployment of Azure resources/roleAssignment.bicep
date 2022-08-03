targetScope = 'managementGroup'

param roleDefinitionId string = 'b24988ac-6180-42a0-ab88-20f7382dd24c' //Default as contributor role
param principalId string = 'msi.properties.principalId'

resource roleassignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(roleDefinitionId)

  properties: {
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalId
  }
}
