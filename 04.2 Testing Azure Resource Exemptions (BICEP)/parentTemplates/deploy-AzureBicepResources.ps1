. './01 variables/variables.ps1' # Dot Source the variables

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

$paramObject = @{
    'subscriptionID' = $variables.subscription_id
    'globalResourceGroupName' = 'Company_Open'
    'localResourceGroupName' = 'Company_Network'
  }

# Correct Deployment which adheres to Policy
New-AzManagementGroupDeployment -Location $variables.location -TemplateFile '.\04.2 Testing Azure Resource Exemptions (BICEP)\parentTemplates\main_correct.bicep' -ManagementGroupId $variables.ManagementGroupId -TemplateParameterObject $paramObject -Name $TimeNow -Verbose

# Wrong Deployment which doesn't adhere to Policy
New-AzManagementGroupDeployment -Location $variables.location -TemplateFile '.\04.2 Testing Azure Resource Exemptions (BICEP)\parentTemplates\main_wrong.bicep' -ManagementGroupId $variables.ManagementGroupId -TemplateParameterObject $paramObject -Name $TimeNow -Verbose

