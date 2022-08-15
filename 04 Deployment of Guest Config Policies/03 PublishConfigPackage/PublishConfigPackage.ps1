$resourceGroupName = 'Company_GuestConfiguration'
$storageAccountName = '20220816stgaccount'
$storageContainerName = 'guestconfiguration'
$location = 'australiaeast'


# If you don't have a storage account, use the following example to create one
# Creates a new resource group, storage account, and container
New-AzResourceGroup -name $resourceGroupName -Location WestUS
New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -SkuName 'Standard_LRS' -Location $location | New-AzStorageContainer -Name $storageContainerName -Permission Blob

# Creates a new container in an existing storage account
$ConnectionString = Read-Host "Enter your SAS token" -AsSecureString
$Context = New-AzStorageContext -ConnectionString (ConvertFrom-SecureString -SecureString $ConnectionString -AsPlainText)

# Next, add the configuration package to the storage account. This example uploads the zip file ./MyConfig.zip to the blob "guestconfiguration".
Set-AzStorageBlobContent -Container $storageContainerName -File './04 Deployment of Guest Config Policies\02 GuestConfigPackage\MyConfig.zip' -Blob "guestconfiguration" -Context $Context

# Optionally, you can add a SAS token in the URL, this ensures that the content package will be accessed securely. The below example generates a blob SAS token with full blob permission and returns the full blob URI with the shared access signature token
$contenturi = New-AzStorageBlobSASToken -Context $Context -FullUri -Container $storageContainerName -Blob "guestconfiguration" -Permission rwd