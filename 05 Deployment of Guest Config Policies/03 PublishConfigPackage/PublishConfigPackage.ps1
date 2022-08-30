$resourceGroupName = 'Company_GuestConfiguration'
$storageAccountName = '20220816stgaccount' # change this, has to be globally unique
$storageContainerName = 'guestconfiguration'
$location = 'australiaeast'
$blob = 'MyConfig.zip'

#-------------------------------------------------------------
# Publish the config package to the storage account
#-------------------------------------------------------------

# If you don't have a storage account, use the following example to create one
# Creates a new resource group, storage account, and container
if(!(Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupName)){
New-AzResourceGroup -name $resourceGroupName -Location $location
New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -SkuName 'Standard_LRS' -Location $location | New-AzStorageContainer -Name $storageContainerName -Permission Blob
}

# Creates a new context for an existing storage account
$context = (Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupName).context

# Next, add the configuration package to the storage account. This example uploads the zip file ./MyConfig.zip to the blob "guestconfiguration".
Set-AzStorageBlobContent -Container $storageContainerName -File './04 Deployment of Guest Config Policies\02 GuestConfigPackage\MyConfig.zip' -Context $Context -Force

# Optionally, you can add a SAS token in the URL, this ensures that the content package will be accessed securely. The below example generates a blob SAS token with full blob permission and returns the full blob URI with the shared access signature token
$contenturi = New-AzStorageBlobSASToken -Context $Context -FullUri -Container $storageContainerName -Blob $blob -Permission rwd -ExpiryTime (Get-Date).AddYears(1)

#-------------------------------------------------------------
# Publish the policy definition
#-------------------------------------------------------------
# Create a Policy Id
$PolicyId = $(New-GUID)
# Define the parameters to create and publish the guest configuration policy
$Params = @{
  "PolicyId" =  $PolicyId
  "ContentUri" =  $ContentURI
  "DisplayName" =  'CustomLocalAdminUser'
  "Description" =  'Custom Local Admin User on Windows'
  "Path" =  './04 Deployment of Guest Config Policies\03 PublishConfigPackage\Policies'
  "Platform" =  'Windows'
  "PolicyVersion" =  '1.0.1'
  "Mode" =  'ApplyAndAutoCorrect'
  "Verbose" = $true
}

# Create the guest configuration policy
New-GuestConfigurationPolicy @Params

#-------------------------------------------------------------
# Deploy the policy definition to Azure
#-------------------------------------------------------------

# Publish the guest configuration policy
New-AzPolicyDefinition -Name 'myFirstMachineConfigDefinition' -Policy './04 Deployment of Guest Config Policies\03 PublishConfigPackage\Policies\MyConfig_DeployIfNotExists.json'