. './01 variables/variables.ps1' # Dot Source the variables

# Create a resource group for the template specs if needed
$TSRG = Get-AzResourceGroup -ResourceGroupName $variables.tsResourceGroupName -Location $variables.location
if($null -eq $TSRG){New-AzResourceGroup -Name $variables.tsResourceGroupName -Location $variables.location}

New-AzTemplateSpec `
  -Name 'Child_AzureResourceAssignments' `
  -Version "1.0.0" `
  -ResourceGroupName $variables.tsResourceGroupName `
  -Location $variables.location `
  -TemplateFile ".\03.2 Deployment of Azure Resource Policies (JSON)\child_PolicyTemplates\policyAssignments.json" `
  -Force

  New-AzTemplateSpec `
  -Name 'Child_AzureResourceDefinitions' `
  -Version "1.0.0" `
  -ResourceGroupName $variables.tsResourceGroupName `
  -Location $variables.location `
  -TemplateFile ".\03.2 Deployment of Azure Resource Policies (JSON)\child_PolicyTemplates\policyDefinitions.json" `
  -Force

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

$paramObject = @{
  'targetSubID' = $variables.subscription_id
  'targetRegion' = $variables.location
  'targetMG' = $variables.ManagementGroupId
  'TS_resourceGroupName' = $variables.tsResourceGroupName
}

New-AzManagementGroupDeployment -Location $variables.location -TemplateFile '.\03.2 Deployment of Azure Resource Policies (JSON)\parent_PolicyTemplates\parentAzurePolicies.json' -ManagementGroupId $variables.ManagementGroupId -TemplateParameterObject $paramObject -Name $TimeNow -Verbose -ErrorAction Continue
