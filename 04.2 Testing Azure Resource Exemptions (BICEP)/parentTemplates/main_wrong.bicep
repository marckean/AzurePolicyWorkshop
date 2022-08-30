targetScope = 'managementGroup'
param localLocation string = 'australiaeast'
param globalLocation string = 'eastus'

param subscriptionID string = '7ac51792-8ea1-4ea8-be56-eb515e42aadf'
param globalResourceGroupName string = 'Company_Open'
param localResourceGroupName string = 'Company_Network'

// Global deployment to the East US region in the global Resource Group
module PIP_module1 '../childTemplates/public_IP_address.bicep' = {
  scope: resourceGroup(subscriptionID, globalResourceGroupName)
  name: 'GlobalRegion_GlobalRG'
  params: {
    location: globalLocation
    name: 'GlobalRegion_GlobalRG'
  }
}

// Global deployment to the East US region in the local Resource Group
module PIP_module2 '../childTemplates/public_IP_address.bicep' = {
  scope: resourceGroup(subscriptionID, localResourceGroupName)
  name: 'GlobalRegion_LocalRG'
  params: {
    location: globalLocation
    name: 'GlobalRegion_LocalRG'
  }
}

// Local deployment to the AU East region in the global Resource Group
module PIP_module3 '../childTemplates/public_IP_address.bicep' = {
  scope: resourceGroup(subscriptionID, globalResourceGroupName)
  name: 'LocalRegion_GlobalRG'
  params: {
    location: localLocation
    name: 'LocalRegion_GlobalRG'
  }
}

// Local deployment to the AU East region in the local Resource Group
module PIP_module4 '../childTemplates/public_IP_address.bicep' = {
  scope: resourceGroup(subscriptionID, localResourceGroupName)
  name: 'LocalRegion_LocalRG'
  params: {
    location: localLocation
    name: 'LocalRegion_LocalRG'
  }
}
