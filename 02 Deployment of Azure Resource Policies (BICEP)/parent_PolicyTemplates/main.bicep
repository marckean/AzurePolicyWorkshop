targetScope = 'managementGroup'

// Resource Groups
var resourceGroups_var = [
  {
    name: 'Company_RG_02'
    location: 'australiaeast'
    resourceGroupName: 'Company_PaaS'
  }
  {
    name: 'Company_RG_03'
    location: 'australiaeast'
    resourceGroupName: 'Company_IaaS'
  }
]

// Tenant
var subscriptionID = '7ac51792-8ea1-4ea8-be56-eb515e42aadf'


// Resource Group scope
module pa1 '../child_PolicyTemplates/policy_assignments.bicep' = {
  //scope: subscription(subscriptionID)
  scope: resourceGroup(subscriptionID, resourceGroups_var[1].resourceGroupName)
  name: 'Company_PolicyAssignment_01'
  params: {
    location: resourceGroups_var[1].outputs.RGLocation
    DCR_ResourceGroupName: resourceGroups_var[0].resourceGroupName
  }
}

