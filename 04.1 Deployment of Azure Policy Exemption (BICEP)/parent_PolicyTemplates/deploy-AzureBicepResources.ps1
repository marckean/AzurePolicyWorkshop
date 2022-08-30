Connect-AzAccount

. './01 variables/variables.ps1' # Dot Source the variables

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

$paramObject = @{
    'subscriptionID' = $variables.subscription_id
  }

# All test Azure resources including NSGs & NSG Security Rukles as both top level resources
New-AzManagementGroupDeployment -Location $variables.location -TemplateFile './03 Deployment of Azure Policy Exemption (BICEP)\parent_PolicyTemplates\main.bicep' -ManagementGroupId $variables.ManagementGroupId -TemplateParameterObject $paramObject -Name $TimeNow -Verbose

# Testing
Test-AzManagementGroupDeployment -Location $variables.location -TemplateFile './03 Deployment of Azure Policy Exemption (BICEP)\parent_PolicyTemplates\main.bicep' -ManagementGroupId $variables.ManagementGroupId -TemplateParameterObject $paramObject -Name $TimeNow -Verbose
