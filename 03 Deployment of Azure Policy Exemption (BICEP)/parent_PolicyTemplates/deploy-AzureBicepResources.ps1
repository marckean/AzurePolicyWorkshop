Connect-AzAccount

$ManagementGroupId = "Test" # this is the root Management Group ID
$location = "australiaeast"

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

# All test Azure resources including NSGs & NSG Security Rukles as both top level resources
New-AzManagementGroupDeployment -Location $location -TemplateFile './03 Deployment of Azure Policy Exemption (BICEP)\parent_PolicyTemplates\main.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose

# Testing
Test-AzManagementGroupDeployment -Location $location -TemplateFile './03 Deployment of Azure Policy Exemption (BICEP)\parent_PolicyTemplates\main.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose
