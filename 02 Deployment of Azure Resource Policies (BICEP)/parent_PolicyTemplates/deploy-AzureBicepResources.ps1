Connect-AzAccount

$ManagementGroupId = "8efecb12-cbaa-4612-b850-e6a68c14d336" # this is the root Management Group ID
$location = "australiaeast"

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

# All test Azure resources including NSGs & NSG Security Rukles as both top level resources
New-AzManagementGroupDeployment -Location $location -TemplateFile './02 Deployment of Azure Resource Policies (BICEP)\parent_PolicyTemplates\main.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose

# Testing
Test-AzManagementGroupDeployment -Location $location -TemplateFile './02 Deployment of Azure Resource Policies (BICEP)\parent_PolicyTemplates\main.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose
