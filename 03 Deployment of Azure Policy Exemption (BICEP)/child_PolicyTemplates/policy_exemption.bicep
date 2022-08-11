
param name string
param displayName string
param description string
param policyAssignmentId string
param exemptionCategory string
param policyDefinitionReferenceIds array
param expiresOn string


// https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-bicep

// Policy Assignment
resource policyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
    name: name
    properties: {
        displayName: displayName
        description: description
        exemptionCategory: exemptionCategory
        policyAssignmentId: policyAssignmentId
        policyDefinitionReferenceIds: policyDefinitionReferenceIds
        expiresOn: expiresOn
    }
}

