param (
    $ManagementGroupId = "Test",
    $location = "australiaeast",
    $ts_resourcegroupname = "TemplateSpecs"
)

# Create a resource group for the template specs if needed
$TSRG = Get-AzResourceGroup -ResourceGroupName $ts_resourcegroupname -Location $location
if($null -eq $TSRG){New-AzResourceGroup -Name $ts_resourcegroupname -Location $location}

New-AzTemplateSpec `
  -Name 'Child_AzureResourceAssignments' `
  -Version "1.0.0" `
  -ResourceGroupName $ts_resourcegroupname `
  -Location $location `
  -TemplateFile ".\02 Deployment of Azure Resource Policies (JSON)\child_PolicyTemplates\policyAssignments.json" `
  -Force

  New-AzTemplateSpec `
  -Name 'Child_AzureResourceDefinitions' `
  -Version "1.0.0" `
  -ResourceGroupName $ts_resourcegroupname `
  -Location $location `
  -TemplateFile ".\02 Deployment of Azure Resource Policies (JSON)\child_PolicyTemplates\policyDefinitions.json" `
  -Force

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

New-AzManagementGroupDeployment -Location $location -TemplateFile '.\02 Deployment of Azure Resource Policies (JSON)\parent_PolicyTemplates\parentAzurePolicies.json' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose -ErrorAction Continue
