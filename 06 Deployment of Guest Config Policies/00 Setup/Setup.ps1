#----------------------------------------
# Remediation of the 'Add system-assigned managed identity to enable Guest Configuration assignments on virtual machines with no identities'
#----------------------------------------

$Initiative = Get-AzPolicySetDefinition -Name '12794019-7a00-42cf-95c2-882eed337cc8' # Deploy prerequisites to enable guest configuration policies on virtual machines

#Get the relevant definition part of the initiative
$definition = $Initiative.Properties.PolicyDefinitions | ? {$_.policyDefinitionReferenceId -eq 'Prerequisite_AddSystemIdentityWhenNone'}

# Get the relevant Policy Assignment to the Initiative
$Assignment = Get-AzPolicyAssignment | where { $_.Properties.PolicyDefinitionId -eq $Initiative.PolicySetDefinitionId}

# Get Policy Rmediations for the Policy Assignment
$remediations = Get-AzPolicyRemediation -Filter "PolicyAssignmentId eq '$($Assignment.PolicyAssignmentId)'" | where {$definition.PolicyDefinitionReferenceId}

# Get most recent remediation
$remediation = $remediations | sort-object -Property CreatedOn -Descending | select -first 1

# Kick off Policy Remediation Task
Start-AzPolicyRemediation -Name $remediation.Name -PolicyAssignmentId $remediation.PolicyAssignmentId

#----------------------------------------
# Install the module from the PowerShell Gallery
#----------------------------------------

# Install the machine configuration DSC resource module from PowerShell Gallery
Install-Module -Name 'GuestConfiguration','PSDesiredStateConfiguration','PSDscResources' -AllowClobber -Force

# Install the machine configuration - user
Install-Module -Name 'GuestConfiguration','PSDesiredStateConfiguration','PSDscResources' -Scope CurrentUser -Repository PSGallery -AllowClobber -Force

# Get a list of commands for the imported GuestConfiguration module
Get-Command -Module 'GuestConfiguration'
