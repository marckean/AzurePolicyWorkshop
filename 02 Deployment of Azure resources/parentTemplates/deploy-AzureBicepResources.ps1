# Sign-in
Connect-AzAccount

Set-AzContext -SubscriptionId $variables.subscription_id

. './01 variables/variables.ps1' # Dot Source the variables

$adminPassword = Read-Host "Enter your local admin password for the VMs" -AsSecureString

$TimeNow = Get-Date -Format yyyyMMdd-hhmm
$paramObject = @{
  'vm_username' = 'superuser'  
  'secret_vm_password' = (ConvertFrom-SecureString -SecureString $adminPassword -AsPlainText)
  'subscriptionID' = $variables.subscription_id
  'tenantID' = $variables.tenant_id
  }

# All test Azure resources including NSGs & NSG Security Rukles as both top level resources
New-AzManagementGroupDeployment -Location $variables.location -TemplateFile '.\02 Deployment of Azure resources\parentTemplates\main.bicep' -ManagementGroupId $variables.ManagementGroupId -Name $TimeNow -TemplateParameterObject $paramObject -Verbose









# DO NOT DEPLOY
# NSGs with the Security Rules as sub-resources
New-AzManagementGroupDeployment -Location $location -TemplateFile './01 Deployment of Azure resources\parentTemplates\main(nsg).bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose