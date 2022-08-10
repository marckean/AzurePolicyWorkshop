targetScope = 'managementGroup'

@description('Definition Management Group Location')
param DefMgmtGroupLoc string
param policyDefinitionName01 string
param policyDefinitionName02 string
param policyDefinitionName03 string
param policyDefinitionName04 string
param policyDefinitionName05 string

@description('role Definition Id Name (Storage Account Contributor)')
param StorageBuiltInRoleName string = 'Storage Account Contributor'

@description('role Definition Id Name (Network Contributor)')
param NetworkBuiltInRoleName string = 'Network Contributor'

@description('Owner BuiltIn Role Name')
param OwnerBuiltInRoleName string = 'Owner'

@description('User Based Access Administrator BuiltIn Role Name')
param UserAccessAdministratorBuiltInRoleName string = 'User Access Administrator'

@description('Location, Region')
param location string

var DefMgmtGroupLoc_var = tenantResourceId('Microsoft.Management/managementGroups', DefMgmtGroupLoc)
var Owner = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
var Contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
var Reader = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
var Storage_Account_Contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')
var Network_Contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
var Key_Vault_Administrator = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483')
var Key_Vault_Contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f25e0fa2-a7c8-4377-a976-54943a77a395')
var User_Access_Administrator = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
var policies = {
  policyAssignments: [
    {
      PolicyAssignmentName: 'AssSecTransStgAcct'
      location: location
      policyAssignmentProperties: {
        displayName: 'Secure transfer to storage accounts should be enabled'
        enforcementMode: 'Default'
        policyDefinitionId: extensionResourceId(DefMgmtGroupLoc_var, 'Microsoft.Authorization/policyDefinitions', policyDefinitionName01)
        nonComplianceMessages: 'Storage accounts must be secured at all times'
      }
    }
    {
      PolicyAssignmentName: 'AssNoRDPSSHInt'
      location: location
      policyAssignmentProperties: {
        displayName: 'No RDP 3389 or SSH 22 from the internet'
        enforcementMode: 'Default'
        policyDefinitionId: extensionResourceId(DefMgmtGroupLoc_var, 'Microsoft.Authorization/policyDefinitions', policyDefinitionName02)
        nonComplianceMessages: 'Ports 3389 and 22 cannot be allowed inbound from the internet'
      }
    }
    {
      PolicyAssignmentName: 'AssKeyVault'
      location: location
      policyAssignmentProperties: {
        displayName: 'Azure KeyVault desired settings'
        enforcementMode: 'Default'
        policyDefinitionId: extensionResourceId(DefMgmtGroupLoc_var, 'Microsoft.Authorization/policyDefinitions', policyDefinitionName04)
        nonComplianceMessages: 'Azure KeyVault must adhere to strict governance'
      }
    }
    {
      PolicyAssignmentName: 'AssDenyCustRole'
      location: location
      policyAssignmentProperties: {
        displayName: 'Deny deployment of a custom role which has the same permissions as the built-in owner role'
        enforcementMode: 'Default'
        policyDefinitionId: extensionResourceId(DefMgmtGroupLoc_var, 'Microsoft.Authorization/policyDefinitions', policyDefinitionName03)
        nonComplianceMessages: 'Cannot deploy a custom role that has the same permissions as the built-in owner role'
      }
    }
    {
      PolicyAssignmentName: 'AssDenyNSG_Rules'
      location: location
      policyAssignmentProperties: {
        displayName: 'Deny deployment of an NSG that contains NSG rules with port 22 or 3389 as destination ports'
        enforcementMode: 'Default'
        policyDefinitionId: extensionResourceId(DefMgmtGroupLoc_var, 'Microsoft.Authorization/policyDefinitions', policyDefinitionName05)
        nonComplianceMessages: 'NSG rules cannot contain port 22 or 3389 as destination ports'
      }
    }
  ]
  roleAssignments: [
    {
      RoleAssignmentName: guid('RoleAssignment', 'AssSecTransStgAcct', uniqueString(subscription().displayName))
      PolicyAssignmentName: 'AssSecTransStgAcct'
      roleAssignmentProperties: {
        roleDefinitionId: Storage_Account_Contributor
        principalType: 'ServicePrincipal'
      }
    }
    {
      RoleAssignmentName: guid('RoleAssignment', 'AssNoRDPSSHInt', uniqueString(subscription().displayName))
      PolicyAssignmentName: 'AssNoRDPSSHInt'
      roleAssignmentProperties: {
        roleDefinitionId: Network_Contributor
        principalType: 'ServicePrincipal'
      }
    }
    {
      RoleAssignmentName: guid('RoleAssignment', 'AssKeyVaultOwner', uniqueString(subscription().displayName))
      PolicyAssignmentName: 'AssKeyVault'
      roleAssignmentProperties: {
        roleDefinitionId: Owner
        principalType: 'ServicePrincipal'
      }
    }
    {
      RoleAssignmentName: guid('RoleAssignment', 'AssKeyVaultUserAccessAdministrator', uniqueString(subscription().displayName))
      PolicyAssignmentName: 'AssKeyVault'
      roleAssignmentProperties: {
        roleDefinitionId: User_Access_Administrator
        principalType: 'ServicePrincipal'
      }
    }
  ]
  remediations: [
    {
      RemediationName: guid('Remediate', 'AssSecTransStgAcct', subscription().displayName)
      location: location
      remediationProperties: {
        locations: [
          location
        ]
        policyAssignmentId: resourceId('Microsoft.Authorization/policyAssignments', 'AssSecTransStgAcct')
        policyDefinitionReferenceId: extensionResourceId(DefMgmtGroupLoc_var, 'Microsoft.Authorization/policyDefinitions', policyDefinitionName01)
        resourceDiscoveryMode: 'ExistingNonCompliant'
        failureThreshold: {
          percentage: 1
        }
        parallelDeployments: 10
        resourceCount: 500
      }
    }
    {
      RemediationName: guid('Remediate', 'AssNoRDPSSHInt', subscription().displayName)
      location: location
      remediationProperties: {
        locations: [
          location
        ]
        policyAssignmentId: resourceId('Microsoft.Authorization/policyAssignments', 'AssNoRDPSSHInt')
        policyDefinitionReferenceId: extensionResourceId(DefMgmtGroupLoc_var, 'Microsoft.Authorization/policyDefinitions', policyDefinitionName02)
        resourceDiscoveryMode: 'ExistingNonCompliant'
        failureThreshold: {
          percentage: 1
        }
        parallelDeployments: 10
        resourceCount: 500
      }
    }
    {
      RemediationName: guid('Remediate', 'AssKeyVault', subscription().displayName)
      location: location
      remediationProperties: {
        locations: [
          location
        ]
        policyAssignmentId: resourceId('Microsoft.Authorization/policyAssignments', 'AssKeyVault')
        policyDefinitionReferenceId: extensionResourceId(DefMgmtGroupLoc_var, 'Microsoft.Authorization/policyDefinitions', policyDefinitionName04)
        resourceDiscoveryMode: 'ExistingNonCompliant'
        failureThreshold: {
          percentage: 1
        }
        parallelDeployments: 10
        resourceCount: 500
      }
    }
  ]
}

resource policies_policyAssignments_PolicyAssignmentName 'Microsoft.Authorization/policyAssignments@2020-09-01' = [for i in range(0, length(policies.policyAssignments)): {
  location: policies.policyAssignments[i].location
  name: policies.policyAssignments[i].PolicyAssignmentName
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: policies.policyAssignments[i].policyAssignmentProperties.displayName
    enforcementMode: policies.policyAssignments[i].policyAssignmentProperties.enforcementMode
    policyDefinitionId: policies.policyAssignments[i].policyAssignmentProperties.policyDefinitionId
    nonComplianceMessages: [
      {
        message: policies.policyAssignments[i].policyAssignmentProperties.nonComplianceMessages
      }
    ]
  }
}]

resource policies_roleAssignments_RoleAssignmentName 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = [for i in range(0, length(policies.roleAssignments)): {
  name: policies.roleAssignments[i].RoleAssignmentName
  properties: {
    roleDefinitionId: policies.roleAssignments[i].roleAssignmentProperties.roleDefinitionId
    principalType: policies.roleAssignments[i].roleAssignmentProperties.principalType
    principalId: reference(resourceId('Microsoft.Authorization/policyAssignments', policies.roleAssignments[i].PolicyAssignmentName), '2021-06-01', 'full').identity.principalId
  }
  dependsOn: [
    policies_policyAssignments_PolicyAssignmentName
  ]
}]

resource policies_remediations_RemediationName 'Microsoft.PolicyInsights/remediations@2021-10-01' = [for i in range(0, length(policies.remediations)): {
  name: policies.remediations[i].RemediationName
  properties: {
    filters: {
      locations: policies.remediations[i].remediationProperties.locations
    }
    policyAssignmentId: policies.remediations[i].remediationProperties.policyAssignmentId
    policyDefinitionReferenceId: policies.remediations[i].remediationProperties.policyDefinitionReferenceId
    resourceDiscoveryMode: policies.remediations[i].remediationProperties.resourceDiscoveryMode
    failureThreshold: {
      percentage: policies.remediations[i].remediationProperties.failureThreshold.percentage
    }
    parallelDeployments: policies.remediations[i].remediationProperties.parallelDeployments
    resourceCount: policies.remediations[i].remediationProperties.resourceCount
  }
  dependsOn: [
    policies_roleAssignments_RoleAssignmentName
    policies_policyAssignments_PolicyAssignmentName
  ]
}]