# Sign-in
Connect-AzAccount

Get-AzSubscription
Set-AzContext -SubscriptionId '7ac51792-8ea1-4ea8-be56-eb515e42aadf'

$ManagementGroupId = "TEST" # this is the root Management Group ID
$location = "australiaeast"

$adminPassword = Read-Host "Enter your local admin password for the VMs" -AsSecureString

$TimeNow = Get-Date -Format yyyyMMdd-hhmm
$paramObject = @{
  'vm_username' = 'superuser'  
  'secret_vm_password' = (ConvertFrom-SecureString -SecureString $adminPassword -AsPlainText)
  }

# All test Azure resources including NSGs & NSG Security Rukles as both top level resources
New-AzManagementGroupDeployment -Location $location -TemplateFile './01 Deployment of Azure resources\parentTemplates\main.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -TemplateParameterObject $paramObject -Verbose









# DO NOT DEPLOY
# NSGs with the Security Rules as sub-resources
New-AzManagementGroupDeployment -Location $location -TemplateFile './01 Deployment of Azure resources\parentTemplates\main(nsg).bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose