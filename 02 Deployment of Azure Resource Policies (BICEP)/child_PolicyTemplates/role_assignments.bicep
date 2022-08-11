param name string
param roleDefinitionId string
param principalType string
param principalId string


// Role Assignment
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
    name: name
    properties: {
        roleDefinitionId: roleDefinitionId
        principalType: principalType
        principalId: principalId
    }
}

