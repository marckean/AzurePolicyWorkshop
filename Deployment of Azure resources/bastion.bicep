param bastionName string
param location string
param virtualNetworkName string
param azureBastionPublicIpName string

var azureBastionPublicIpId = resourceId('Microsoft.Network/publicIPAddresses', azureBastionPublicIpName)
var vNetId = resourceId('Microsoft.Network/virtualNetworks', virtualNetworkName)

resource bastion01 'Microsoft.Network/bastionHosts@2021-08-01' = {
  name: bastionName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    enableFileCopy: true
    disableCopyPaste: false
    ipConfigurations: [
      {
        name: 'IpConfAzureBastionSubnet'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: azureBastionPublicIpId
          }
          subnet: {
            id: '${vNetId}/subnets/AzureBastionSubnet'
          }
        }
      }
    ]
  }
}
