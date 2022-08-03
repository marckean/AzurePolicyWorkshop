param virtualNetworkName string
param location string
param addressSpace_addressPrefixes array

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressSpace_addressPrefixes
    }
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}
