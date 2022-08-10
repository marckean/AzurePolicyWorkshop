targetScope = 'managementGroup'

param DCR_ResourceGroupName string = 'Company_PaaS'
param DCR_Name string = 'AllSystemInformation'

// Tenant
var subscriptionID = '7ac51792-8ea1-4ea8-be56-eb515e42aadf'
var subscriptionDisplayName = 'CSR-CUSPOC-NMST-makean'
var ManagemantGroup = 'Test'

var location_var = 'australiaeast'
var Virtual_Machine_Contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
var Monitoring_Contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
var Log_Analytics_Contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')

var policyAssignments_var = [
  {
    policyAssignmentName: 'PolicyAssignment01'
    policyAssignmentDisplayName: 'Configure Windows machines to run Azure Monitor Agent and associate them to a Data Collection Rule'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/9575b8b7-78ab-4281-b53b-d3c1ace2260b'
    enforcementMode: 'Default'
    identity: {
      type: 'SystemAssigned'
    }
    parameters: {
      DcrResourceId: {
        value: resourceId(subscriptionID, DCR_ResourceGroupName, 'Microsoft.Insights/dataCollectionRules', DCR_Name)
      }
    }
    nonComplianceMessages: [
      {
        message: 'Windows machines cannot run Azure Monitor Agent and be associated to a Data Collection Rule'
      }
    ]
    scope: resourceGroup(subscriptionID, DCR_ResourceGroupName)
  }
]

var roleAssignments_var = [
  {
    roleAssignmentName: guid('RoleAssignment01', policyAssignments_var[0].policyAssignmentName, uniqueString(subscriptionDisplayName))
    roleDefinitionId: Virtual_Machine_Contributor
    principalType: 'ServicePrincipal'
    scope: subscription(subscriptionID)
  }
  {
    roleAssignmentName: guid('RoleAssignment02', policyAssignments_var[0].policyAssignmentName, uniqueString(subscriptionDisplayName))
    roleDefinitionId: Monitoring_Contributor
    principalType: 'ServicePrincipal'
    scope: subscription(subscriptionID)
  }
  {
    roleAssignmentName: guid('RoleAssignment03', policyAssignments_var[0].policyAssignmentName, uniqueString(subscriptionDisplayName))
    roleDefinitionId: Log_Analytics_Contributor
    principalType: 'ServicePrincipal'
    scope: subscription(subscriptionID)
  }
]

var remediations_var = [
  {
    remediationName: guid('Remediate', policyAssignments_var[0].policyAssignmentName, subscriptionDisplayName)
    DefMgmtGroup: tenantResourceId('Microsoft.Management/managementGroups', ManagemantGroup)
    policyDefinitionName: 'Configure Windows machines to run Azure Monitor Agent and associate them to a Data Collection Rule'
    policyAssignmentId: resourceId('Microsoft.Authorization/policyAssignments', policyAssignments_var[0].policyAssignmentName)
    resourceDiscoveryMode: 'ExistingNonCompliant'
    filters: {
      locations: [
        location_var
      ]
    }
    failureThreshold: {
      percentage: 1
    }
    scope: subscription(subscriptionID)
  }
]

// Resource Group scope
module pa '../child_PolicyTemplates/policy_assignments.bicep' = [for policyAssignment in policyAssignments_var: {
  name: policyAssignment.policyAssignmentName
  scope: policyAssignment.scope
  params: {
    name: policyAssignment.policyAssignmentName
    location: location_var
    identity: policyAssignment.identity
    displayName: policyAssignment.policyAssignmentDisplayName
    enforcementMode: policyAssignment.enforcementMode
    policyDefinitionId: policyAssignment.policyDefinitionId
    parameters: policyAssignment.parameters
    nonComplianceMessages: policyAssignment.nonComplianceMessages
  }
}]

// Role Assignment
module ra '../child_PolicyTemplates/role_assignments.bicep' = [for roleAssignment in roleAssignments_var: {
  name: roleAssignment.roleAssignmentName
  scope: subscription(subscriptionID)
  params: {
    name: guid(roleAssignment.roleAssignmentName, roleAssignment.policyAssignmentName, uniqueString(subscriptionDisplayName))
    roleDefinitionId: roleAssignment.roleDefinitionId
    principalType: roleAssignment.principalType
    //principalId: reference(resourceId('Microsoft.Authorization/policyAssignments', policyAssignments_var[0].policyAssignmentName), '2022-06-01', 'full').identity.principalId
    principalId: (/subscriptions/7ac51792-8ea1-4ea8-be56-eb515e42aadf/resourcegroups/Company_PaaS/providers/Microsoft.Authorization/policyAssignments/PolicyAssignment01).identity.principalId
  }
  dependsOn: [
    pa
  ]
}]

// Resource Group scope
module rem '../child_PolicyTemplates/remediations.bicep' = [for remediation in remediations_var: {
  name: remediation.remediationName
  scope: subscription(subscriptionID)
  params: {
    name: remediation.remediationName
    filters: remediation.filters
    policyAssignmentId: remediation.policyAssignmentId
    policyDefinitionReferenceId: extensionResourceId(remediation.DefMgmtGroup, 'Microsoft.Authorization/policyDefinitions', remediation.policyDefinitionName)
    resourceDiscoveryMode: remediation.resourceDiscoveryMode
    failureThreshold: remediation.failureThreshold
    parallelDeployments: 10
    resourceCount: 500
  }
  dependsOn: [
    pa
    ra
  ]
}]
