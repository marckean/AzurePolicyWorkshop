targetScope = 'managementGroup'

// Tenant
param subscriptionID string

var exemptions_var = [
  {
    name: 'exemptFromLocationRestrictions'
    displayName: 'Exempt from restricted locations, can deploy resources in any location'
    description: 'Exempt from restricted locations, can deploy resources in any location'
    policyAssignmentId: '/subscriptions/${subscriptionID}/providers/Microsoft.Authorization/policyAssignments/Allowed_Locations'
    exemptionCategory: 'Mitigated'
    policyDefinitionReferenceIds: [
    ]
    expiresOn: '2022-12-31T23:59:00.0000000Z'
    subscriptionId: subscriptionID
    resourceGroupName: 'Company_Open'
  }
]

// Role Assignment
module policyExemption '../child_PolicyTemplates/policy_exemption.bicep' = [for exemption in exemptions_var: {
  name: exemption.name
  scope: resourceGroup(exemption.subscriptionId, exemption.resourceGroupName)
  params: {
    name: exemption.name
    displayName: exemption.displayName
    description: exemption.description
    policyAssignmentId: exemption.policyAssignmentId
    exemptionCategory: exemption.exemptionCategory
    policyDefinitionReferenceIds: exemption.policyDefinitionReferenceIds
    expiresOn: exemption.expiresOn
  }
}]


