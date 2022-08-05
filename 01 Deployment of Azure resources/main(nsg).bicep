targetScope = 'managementGroup'

param RG_name string = 'Company_NSG'
param location string = 'australiaeast'

var subscriptionID = '7ac51792-8ea1-4ea8-be56-eb515e42aadf'

//https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-to-management-group?tabs=azure-cli

// Subscription scope
module RG_01 './resource-group.bicep' = {
  name: 'Company_NSG'
  scope: subscription(subscriptionID)
  params: {
    location: location
    RG_name: RG_name
  }
}

// Resource Group scope
module nsg1 './nsg_22_3389.bicep' = {
  scope: resourceGroup(subscriptionID, RG_name)
  name: 'Company_NSG_22_3389_01'
  params: {
    location: RG_01.outputs.RGLocation
  }
}

// Resource Group scope
module nsg2 './nsg_443.bicep' = {
  scope: resourceGroup(subscriptionID, RG_name)
  name: 'Company_NSG_443_01'
  params: {
    location: RG_01.outputs.RGLocation
  }
}
