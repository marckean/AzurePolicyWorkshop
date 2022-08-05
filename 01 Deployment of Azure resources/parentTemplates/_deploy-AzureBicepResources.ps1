Connect-AzAccount

$ManagementGroupId = "8efecb12-cbaa-4612-b850-e6a68c14d336" # this is the root Management Group ID
$location = "australiaeast"

$adminPassword = Read-Host "Enter your local admin password for the VMs" -AsSecureString

$TimeNow = Get-Date -Format yyyyMMdd-hhmm
$paramObject = @{
  'vm_username' = 'superuser'  
  'secret_vm_password' = (ConvertFrom-SecureString -SecureString $adminPassword -AsPlainText)
  }

# All test Azure resources
New-AzManagementGroupDeployment -Location $location -TemplateFile '../parentTemplates/main.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -TemplateParameterObject $paramObject -Verbose

