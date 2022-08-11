@description('Specifies the ID of the policy definition or policy set definition being assigned.')
param BuiltIn_PolicyDefinitionID string = '9575b8b7-78ab-4281-b53b-d3c1ace2260b' //Configure Windows machines to run Azure Monitor Agent and associate them to a Data Collection Rule
param location string = 'australiaeast'
param ManagemantGroup string = 'Test'
param DCR_ResourceGroupName string
param DCR_Name string = 'AllSystemInformation'

@description('Specifies the name of the policy assignment, can be used defined or an idempotent name as the defaultValue provides.')
var policyAssignmentName01 = guid(BuiltIn_PolicyDefinitionID, subscription().displayName)
var DefMgmtGroupLoc_var = tenantResourceId('Microsoft.Management/managementGroups', ManagemantGroup)
var Virtual_Machine_Contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
var Monitoring_Contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
var Log_Analytics_Contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
var policyDefinitionName01 = 'Configure Windows machines to run Azure Monitor Agent and associate them to a Data Collection Rule'
var policyAssignmentDisplayName01 = 'Configure Windows machines to run Azure Monitor Agent and associate them to a Data Collection Rule'


// https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-bicep

// Policy Assignment 01

resource policyAssignment01 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
    name: policyAssignmentName01
    location: location
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        displayName: policyAssignmentDisplayName01
        enforcementMode: 'Default'
        //scope: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', policyDefinitionID)
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policySetDefinitions', BuiltIn_PolicyDefinitionID)
        parameters:{
            DcrResourceId: {
                value: resourceId(subscription().subscriptionId, DCR_ResourceGroupName, 'Microsoft.Insights/dataCollectionRules', DCR_Name)
            }
        }
    }
}

resource roleAssignment01 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
    name: guid('RoleAssignment01', policyAssignmentName01, uniqueString(subscription().displayName))
    properties: {
        roleDefinitionId: Virtual_Machine_Contributor
        principalType: 'ServicePrincipal'
        principalId: reference(policyAssignment01.id, '2021-06-01', 'full').identity.principalId
    }
}

resource roleAssignment02 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
    name: guid('RoleAssignment02', policyAssignmentName01, uniqueString(subscription().displayName))
    properties: {
        roleDefinitionId: Monitoring_Contributor
        principalType: 'ServicePrincipal'
        principalId: reference(policyAssignment01.id, '2021-06-01', 'full').identity.principalId
    }
}

resource roleAssignment03 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
    name: guid('RoleAssignment03', policyAssignmentName01, uniqueString(subscription().displayName))
    properties: {
        roleDefinitionId: Log_Analytics_Contributor
        principalType: 'ServicePrincipal'
        principalId: reference(policyAssignment01.id, '2021-06-01', 'full').identity.principalId
    }
}

resource remediate_policyAssignment01 'Microsoft.PolicyInsights/remediations@2021-10-01' = {
    name: guid('Remediate', policyAssignmentName01, subscription().displayName)
    properties: {
        filters: {
            locations: [
                location
            ]
        }
        policyAssignmentId: policyAssignment01.id
        policyDefinitionReferenceId: extensionResourceId(DefMgmtGroupLoc_var, 'Microsoft.Authorization/policyDefinitions', policyDefinitionName01)
        resourceDiscoveryMode: 'ExistingNonCompliant'
        failureThreshold: {
            percentage: 1
        }
        parallelDeployments: 10
        resourceCount: 500
    }
    dependsOn: [
        roleAssignment01
    ]
}

output assignmentId string = policyAssignment01.id
