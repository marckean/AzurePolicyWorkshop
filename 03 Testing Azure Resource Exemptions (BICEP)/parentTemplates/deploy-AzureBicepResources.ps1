Connect-AzAccount

$ManagementGroupId = "8efecb12-cbaa-4612-b850-e6a68c14d336" # this is the root Management Group ID
$location = "australiaeast"

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

# Correct Deployment which adheres to Policy
New-AzManagementGroupDeployment -Location $location -TemplateFile './03 Deployment of Azure Resource Exemptions (BICEP)\parentTemplates\main_correct.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose

# Wrong Deployment which doesn't adhere to Policy
New-AzManagementGroupDeployment -Location $location -TemplateFile './03 Deployment of Azure Resource Exemptions (BICEP)\parentTemplates\main_wrong.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose

