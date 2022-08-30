Connect-AzAccount

. './01 variables/variables.ps1' # Dot Source the variables

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

$paramObject = @{
    'subscriptionID' = $variables.subscription_id
    'subscriptionDisplayName' = $variables.subscription_name
    'ManagemantGroup' = $variables.ManagementGroupId
    
  }

# All test Azure resources including NSGs & NSG Security Rukles as both top level resources
New-AzManagementGroupDeployment -Location $variables.location -TemplateFile './02 Deployment of Azure Resource Policies (BICEP)\parent_PolicyTemplates\main.bicep' -ManagementGroupId $variables.ManagementGroupId -Name $TimeNow -TemplateParameterObject $paramObject -Verbose

# Testing
Test-AzManagementGroupDeployment -Location $variables.location -TemplateFile './02 Deployment of Azure Resource Policies (BICEP)\parent_PolicyTemplates\main.bicep' -ManagementGroupId $variables.ManagementGroupId -Name $TimeNow -TemplateParameterObject $paramObject -Verbose

