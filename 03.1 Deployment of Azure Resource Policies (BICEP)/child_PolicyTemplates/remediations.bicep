targetScope = 'subscription'

param name string
param filters object
param policyAssignmentId string
param policyDefinitionReferenceId string
param failureThreshold object
param parallelDeployments int
param resourceCount int
param resourceDiscoveryMode string

resource remediation_res 'Microsoft.PolicyInsights/remediations@2021-10-01' = {
    name: name
    properties: {
        filters: filters
        policyAssignmentId: policyAssignmentId
        policyDefinitionReferenceId: policyDefinitionReferenceId
        resourceDiscoveryMode: resourceDiscoveryMode
        failureThreshold: failureThreshold
        parallelDeployments: parallelDeployments
        resourceCount: resourceCount
    }
}

