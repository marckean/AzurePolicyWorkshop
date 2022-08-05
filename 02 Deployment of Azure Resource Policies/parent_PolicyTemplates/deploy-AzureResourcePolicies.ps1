param (
    $ManagementGroupId = "8efecb12-cbaa-4612-b850-e6a68c14d336",
    $location = "australiaeast",
    $ts_resourcegroupname = "TemplateSpecs"
)

New-AzTemplateSpec `
  -Name 'Child_AzureResourceAssignments' `
  -Version "1.0.0" `
  -ResourceGroupName $ts_resourcegroupname `
  -Location $location `
  -TemplateFile ".\02 Deployment of Azure Resource Policies\child_PolicyTemplates\policyAssignments.json" `
  -Force

  New-AzTemplateSpec `
  -Name 'Child_AzureResourceDefinitions' `
  -Version "1.0.0" `
  -ResourceGroupName $ts_resourcegroupname `
  -Location $location `
  -TemplateFile ".\02 Deployment of Azure Resource Policies\child_PolicyTemplates\policyDefinitions.json" `
  -Force

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

New-AzManagementGroupDeployment -Location $location -TemplateFile '.\02 Deployment of Azure Resource Policies\parent_PolicyTemplates\parentAzurePolicies.json' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose -ErrorAction Continue
