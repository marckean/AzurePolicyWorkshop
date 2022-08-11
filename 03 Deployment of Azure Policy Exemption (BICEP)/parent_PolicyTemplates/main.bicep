targetScope = 'managementGroup'

param DCR_ResourceGroupName string = 'Company_PaaS'
param DCR_Name string = 'AllSystemInformation'



// Tenant
var subscriptionID = '7ac51792-8ea1-4ea8-be56-eb515e42aadf'
var subscriptionDisplayName = 'CSR-CUSPOC-NMST-makean'

var exemptions_var = [
  {
    name: 'exemptFromLocations'
  }
  
]

// Role Assignment
module policyExemption '../child_PolicyTemplates/policy_exemption.bicep' = [for exemption in exemptions_var: {
  name: exemption.name
  scope: resourceGroup(roleAssignment.subscriptionId, roleAssignment.resourceGroupName)
  params: {
    name: guid(roleAssignment.roleAssignmentName, roleAssignment.policyAssignmentName, uniqueString(subscriptionDisplayName))
    roleDefinitionId: roleAssignment.roleDefinitionId
    principalType: roleAssignment.principalType
    principalId: reference(resourceId(subscriptionID, DCR_ResourceGroupName, 'Microsoft.Authorization/policyAssignments', policyAssignments_RG_var[0].policyAssignmentName), '2022-06-01', 'full').identity.principalId
  }
}]

