Connect-AzAccount

$ManagementGroupId = "Test" # this is the root Management Group ID
$location = "australiaeast"

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

# Correct Deployment which adheres to Policy
New-AzManagementGroupDeployment -Location $location -TemplateFile './03 Testing Azure Resource Exemptions (BICEP)\parentTemplates\main_correct.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose

# Wrong Deployment which doesn't adhere to Policy
New-AzManagementGroupDeployment -Location $location -TemplateFile './03 Testing Azure Resource Exemptions (BICEP)\parentTemplates\main_wrong.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose

