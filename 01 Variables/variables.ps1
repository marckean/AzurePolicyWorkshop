$random = Get-Random -Minimum 0000000000 -Maximum 999999999999

$variables = @{
    'subscription_id' = '7ac51792-8ea1-4ea8-be56-eb515e42aadf'
    'tenant_id' = '8efecb12-cbaa-4612-b850-e6a68c14d336'
    'subscription_name' = 'CSR-CUSPOC-NMST-makean'
    'ManagementGroupId' = 'TEST' # this is the root Management Group ID
    'location' = 'australiaeast'
    'tsResourceGroupName' = 'TemplateSpecs' # Resource Group name for the Template Specs child templates
    'gcResourceGroupName' = 'Company_GuestConfiguration' # Resource Group name for Guest Configuration storage account
    'gcStorageAccountName' = "gcstg$random" # Storage account name for gust configuration
    'gcStorageContainerName' = 'guestconfiguration' # Storage account name for guest configuration
    'gcStorageBlobName' = 'MyConfig' # Storage account blob name for guest configuration package (ZIP file)
}
