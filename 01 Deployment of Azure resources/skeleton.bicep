targetScope = 'managementGroup'
//https://github.com/Azure/bicep/issues/1231
resource dinePolicy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'test'
  properties: {
    policyType: 'Custom'
    policyRule: {
      if: {
        // ...
      }
      then: {
        effect: 'DeployIfNotExists'
        details: {
          type: ''
          name: ''
          roleDefinitionIds: [
            // ...
          ]
          existenceCondition: {
            // ...
          }
          deployment: {
            properties: {
              mode: 'Incremental'
              template: {
                '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                resources: [
                  {
                    type: '...'
                    apiVersion: '...'
                    name: '...'
                    properties: {}
                  }
                ]
              }
            }
          }
        }
      }
    }
  }
}
