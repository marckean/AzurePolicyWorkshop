targetScope = 'resourceGroup'

param managedIdentityName string
param location string

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

output principalId string = msi.properties.principalId
