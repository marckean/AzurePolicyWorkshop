param (
    $ManagementGroupId = "8efecb12-cbaa-4612-b850-e6a68c14d336",
    $location = "australiaeast",
    $ts_resourcegroupname = "TemplateSpecs"
)

New-AzTemplateSpec `
  -Name 'Child_GuestConfigurationAssignments' `
  -Version "1.0.0" `
  -ResourceGroupName $ts_resourcegroupname `
  -Location $location `
  -TemplateFile ".\04 Deployment of Guest Config Policies\child_PolicyTemplates\policyAssignments.json" `
  -Force

  New-AzTemplateSpec `
  -Name 'Child_GuestConfigurationDefinitions' `
  -Version "1.0.0" `
  -ResourceGroupName $ts_resourcegroupname `
  -Location $location `
  -TemplateFile ".\04 Deployment of Guest Config Policies\child_PolicyTemplates\policyDefinitions.json" `
  -Force

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

New-AzManagementGroupDeployment -Location $location -TemplateFile '.\04 Deployment of Guest Config Policies\parent_PolicyTemplates\parentGuestConfiguration.json' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose -ErrorAction Continue
