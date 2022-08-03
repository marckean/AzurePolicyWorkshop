param location string = resourceGroup().location
param tenantID string
param objectID string

resource kv1 'Microsoft.KeyVault/vaults@2021-10-01' = {
    name: 'HAKeyVaultRight'
    location: location
    properties:{
        sku: {
            family: 'A'
            name: 'standard'
        }
        accessPolicies: [
            {
              objectId: objectID
              tenantId: tenantID
              permissions: {
                secrets: [
                  'list'
                ]
                certificates: [
                  'list'
                ]
              }
            }
          ]
        tenantId: tenantID
        enableRbacAuthorization: true
        enableSoftDelete: true
        softDeleteRetentionInDays: 90
    }
}

resource kv2 'Microsoft.KeyVault/vaults@2021-10-01' = {
    name: 'HAKeyVaultWrong'
    location: location
    properties:{
        sku: {
            family: 'A'
            name: 'standard'
        }
        accessPolicies: [
            {
              objectId: objectID
              tenantId: tenantID
              permissions: {
                secrets: [
                  'list'
                ]
                certificates: [
                  'list'
                ]
              }
            }
          ]
        tenantId: tenantID
        enableRbacAuthorization: false
        enableSoftDelete: false
        softDeleteRetentionInDays: 72
    }
} 

output kvid1 string = kv1.id
output kvid2 string = kv2.id
