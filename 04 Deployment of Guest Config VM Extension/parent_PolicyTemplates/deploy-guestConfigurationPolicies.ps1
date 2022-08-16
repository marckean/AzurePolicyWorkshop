param (
    $ManagementGroupId = "8efecb12-cbaa-4612-b850-e6a68c14d336",
    $location = "australiaeast",
    $ts_resourcegroupname = "TemplateSpecs"
)

New-AzTemplateSpec `
  -Name 'Child_GuestConfigurationAssignmentsSystem' `
  -Version "1.0.0" `
  -ResourceGroupName $ts_resourcegroupname `
  -Location $location `
  -TemplateFile ".\04 Deployment of Guest Config VM Extension\parent_PolicyTemplates\parentGuestConfiguration.json" `
  -Force


$TimeNow = Get-Date -Format yyyyMMdd-hhmm

#New-AzManagementGroupDeployment -Location $location -TemplateFile '.\03 Deployment of Guest Config Policies (system)\parent_PolicyTemplates\parentGuestConfiguration.json' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose -ErrorAction Continue

#New-AzSubscriptionDeployment -Location $location -TemplateFile '.\04 Deployment of Guest Config VM Extension\parent_PolicyTemplates\parentGuestConfiguration.json' -Name $TimeNow -Verbose -ErrorAction Continue

New-AzSubscriptionDeployment -Location $location -TemplateFile '.\04 Deployment of Guest Config VM Extension\child_PolicyTemplates\policyAssignments.json' -Name $TimeNow -Verbose -ErrorAction Continue


######## Testing - do not run
$lastDeploymentName = (Get-AzSubscriptionDeployment | where {$_.ProvisioningState -ne 'Succeeded'} | sort Timestamp -Descending)[0].DeploymentName
if($lastDeploymentName){Remove-AzSubscriptionDeployment -Name $lastDeploymentName}


