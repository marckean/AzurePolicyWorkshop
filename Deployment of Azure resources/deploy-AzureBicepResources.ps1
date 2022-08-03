Connect-AzAccount

$ManagementGroupId = "8efecb12-cbaa-4612-b850-e6a68c14d336" # this is the root Management Group ID
$location = "australiaeast"

$adminPassword = Read-Host "Enter Your Password" -AsSecureString

$TimeNow = Get-Date -Format yyyyMMdd-hhmm
$paramObject = @{
    'secret_vm_password' = (ConvertFrom-SecureString -SecureString $adminPassword -AsPlainText)
  }

# All test resources, with the NSG and NSG rules as separate
New-AzManagementGroupDeployment -Location $location -TemplateFile '.\TestEnvironment-Full\main.bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -TemplateParameterObject $paramObject -Verbose

# NSG with rules included - ONLY
New-AzManagementGroupDeployment -Location $location -TemplateFile '.\TestEnvironment-Full\main(nsg).bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose

#az deployment mg create --location $location --management-group-id $ManagementGroupId --template-file 'C:\Users\makean\Documents\Github\AzureBicep\main.bicep' --verbose
