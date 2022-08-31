. './01 variables/variables.ps1' # Dot Source the variables

#-------------------------------------------------------------
# Publish the config package to the storage account
#-------------------------------------------------------------

# If you don't have a storage account, use the following example to create one
# Creates a new resource group, storage account, and container
if (!(Get-AzStorageAccount -Name $variables.gcStorageAccountName -ResourceGroupName $variables.gcResourceGroupName -ErrorAction silentlycontinue)) {
  
  # Creates a Resource Group is none exists
  if (!(Get-AzResourceGroup -name $variables.gcStorageAccountName -ErrorAction silentlycontinue)) {
    New-AzResourceGroup -name $variables.gcResourceGroupName -Location $variables.location
  }
  New-AzStorageAccount -ResourceGroupName $variables.gcResourceGroupName -Name $variables.gcStorageAccountName -SkuName 'Standard_LRS' -Location $variables.location -EnableHttpsTrafficOnly $true -AllowBlobPublicAccess $false
}

# Creates a new context for an existing storage account
$context = (Get-AzStorageAccount -Name $variables.gcStorageAccountName -ResourceGroupName $variables.gcResourceGroupName).context

# Creates a new container for the storage account with public access setting set to Off
New-AzStorageContainer -Name $variables.gcStorageContainerName -Permission Off -Context $context

# Next, add the configuration package to the storage account. This example uploads the zip file ./MyConfig.zip to the blob "guestconfiguration".
Set-AzStorageBlobContent -Container $variables.gcStorageContainerName -File '.\06 Deployment of Guest Config Policies\02 GuestConfigPackage\MyConfig.zip' -Context $Context -Force

# Optionally, you can add a SAS token in the URL, this ensures that the content package will be accessed securely. The below example generates a blob SAS token with full blob permission and returns the full blob URI with the shared access signature token
$contenturi = New-AzStorageBlobSASToken -Context $Context -FullUri -Container $variables.gcStorageContainerName -Blob "$($variables.gcStorageBlobName).zip" -Permission rwd -ExpiryTime (Get-Date).AddYears(1)

#-------------------------------------------------------------
# Publish the policy definition
#-------------------------------------------------------------
# Create a Policy Id
$PolicyId = $(New-GUID)
# Define the parameters to create and publish the guest configuration policy
$Params = @{
  "PolicyId"      = $PolicyId
  "ContentUri"    = $ContentURI
  "DisplayName"   = 'CustomLocalAdminUser'
  "Description"   = 'Custom Local Admin User on Windows'
  "Path"          = '.\06 Deployment of Guest Config Policies\03 PublishConfigPackage\Policies'
  "Platform"      = 'Windows'
  "PolicyVersion" = '1.0.1'
  "Mode"          = 'ApplyAndAutoCorrect'
  "Verbose"       = $true
}

# Create the guest configuration policy
New-GuestConfigurationPolicy @Params

#-------------------------------------------------------------
# Deploy the policy definition to Azure
#-------------------------------------------------------------

# Publish the guest configuration policy to the management group
New-AzPolicyDefinition -Name 'myFirstMachineConfigDefinition' -Policy ".\06 Deployment of Guest Config Policies\03 PublishConfigPackage\Policies\MyConfig_DeployIfNotExists.json" -ManagementGroupName $variables.ManagementGroupId

#-------------------------------------------------------------
# Assign the policy definition in the Azure portal
#-------------------------------------------------------------