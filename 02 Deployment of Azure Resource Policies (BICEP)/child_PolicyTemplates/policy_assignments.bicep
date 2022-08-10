param name string
param location string
param identity object
param displayName string
param enforcementMode string
param policyDefinitionId string
param parameters object
param nonComplianceMessages array

// https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-bicep

// Policy Assignment
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
    name: name
    location: location
    identity: identity
    properties: {
        displayName: displayName
        enforcementMode: enforcementMode
        policyDefinitionId: policyDefinitionId
        parameters: parameters
        nonComplianceMessages: nonComplianceMessages
    }
}

output policyAssignmentId string = policyAssignment.id
