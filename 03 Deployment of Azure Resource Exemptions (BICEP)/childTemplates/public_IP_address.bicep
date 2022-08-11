@description('Required. The name of the Public IP Address.')
param name string

@description('Optional. Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.')
param publicIPPrefixResourceId string = ''

@description('Optional. The public IP address allocation method.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string = 'Static'

@description('Optional. Name of a public IP address SKU.')
@allowed([
  'Basic'
  'Standard'
])
param skuName string = 'Standard'

@description('Optional. Tier of a public IP address SKU.')
@allowed([
  'Global'
  'Regional'
])
param skuTier string = 'Regional'

@description('Optional. A list of availability zones denoting the IP allocated for the resource needs to come from.')
param zones array = []

@description('Optional. IP address version.')
@allowed([
  'IPv4'
  'IPv6'
])
param publicIPAddressVersion string = 'IPv4'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}



var publicIPPrefix = {
  id: publicIPPrefixResourceId
}

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  zones: zones
  properties: {
    publicIPAddressVersion: publicIPAddressVersion
    publicIPAllocationMethod: publicIPAllocationMethod
    publicIPPrefix: !empty(publicIPPrefixResourceId) ? publicIPPrefix : null
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}


@description('The resource group the public IP address was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the public IP address.')
output name string = publicIpAddress.name

@description('The resource ID of the public IP address.')
output resourceId string = publicIpAddress.id

@description('The location the resource was deployed into.')
output location string = publicIpAddress.location
