param (
    $ManagementGroupId = "8efecb12-cbaa-4612-b850-e6a68c14d336",
    $location = "australiaeast",
    $ts_resourcegroupname = "TemplateSpecs"
)

New-AzTemplateSpec `
  -Name 'Child_GuestConfigurationAssignment' `
  -Version "1.0.0" `
  -ResourceGroupName $ts_resourcegroupname `
  -Location $location `
  -TemplateFile ".\child_templates\guestConfigurationPolicy\policyAssignments.json" `
  -Force

New-AzManagementGroupDeployment -Location $location -TemplateFile '.\parent_templates\policyGuestConfiguration\parentGuestConfiguration.json' -ManagementGroupId $ManagementGroupId -Verbose -ErrorAction Continue
