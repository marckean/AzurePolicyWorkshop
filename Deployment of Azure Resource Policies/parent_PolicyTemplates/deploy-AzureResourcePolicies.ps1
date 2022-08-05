param (
    $ManagementGroupId = "8efecb12-cbaa-4612-b850-e6a68c14d336",
    $location = "australiaeast",
    $ts_resourcegroupname = "TemplateSpecs"
)

New-AzTemplateSpec `
  -Name 'TS_policyAssignments' `
  -Version "2.0.2" `
  -ResourceGroupName $ts_resourcegroupname `
  -Location $location `
  -TemplateFile ".\artifacts\policyAssignments.json" `
  -Force

  New-AzTemplateSpec `
  -Name 'TS_policyDefinitions' `
  -Version "2.0.2" `
  -ResourceGroupName $ts_resourcegroupname `
  -Location $location `
  -TemplateFile ".\artifacts\policyDefinitions.json" `
  -Force

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

New-AzManagementGroupDeployment -Location $location -TemplateFile '.\deploy.json' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose -ErrorAction Continue
