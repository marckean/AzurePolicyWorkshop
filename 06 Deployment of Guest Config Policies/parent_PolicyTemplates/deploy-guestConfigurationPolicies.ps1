. './01 variables/variables.ps1' # Dot Source the variables

New-AzTemplateSpec `
  -Name 'Child_GuestConfigurationAssignmentsSystem' `
  -Version "1.0.0" `
  -ResourceGroupName $variables.tsResourceGroupName `
  -Location $variables.location `
  -TemplateFile ".\04 Deployment of Guest Config Policies (system)\parent_PolicyTemplates\parentGuestConfiguration.json" `
  -Force


$TimeNow = Get-Date -Format yyyyMMdd-hhmm

$paramObject = @{
  'targetSubID' = $variables.subscription_id
  'targetRegion' = $variables.location
  'tsResourceGroupName' = $variables.tsResourceGroupName
}

#New-AzManagementGroupDeployment -Location $variables.location -TemplateFile '.\03 Deployment of Guest Config Policies (system)\parent_PolicyTemplates\parentGuestConfiguration.json' -ManagementGroupId $variables.ManagementGroupId -Name $TimeNow -Verbose -ErrorAction Continue

New-AzSubscriptionDeployment -Location $variables.location -TemplateFile '.\04 Deployment of Guest Config Policies (system)\child_PolicyTemplates\policyAssignments.json' -TemplateParameterObject $paramObject -Name $TimeNow -Verbose -ErrorAction Continue
