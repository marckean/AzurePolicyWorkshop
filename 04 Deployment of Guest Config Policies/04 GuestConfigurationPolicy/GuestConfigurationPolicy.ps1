New-GuestConfigurationPolicy `
 -PolicyId 'My GUID' `
 -ContentUri '<paste the ContentUri output from the Publish command>' `
 -DisplayName 'My audit policy.' `
 -Description 'Details about my policy.' `
 -Path '.\04 Deployment of Guest Config Policies\03 GuestConfigurationPolicy\policies' `
 -Platform 'Windows' `
 -PolicyVersion 1.0.0 `
 -Mode 'ApplyAndAutoCorrect' `
 -Verbose


# Publish the guest configuration package (zip) to the storage account
$ContentURI = Publish-GuestConfigurationPackage -Path './ISO1773.zip' -ResourceGroupName AzurePolicy -StorageAccountName $StorageAccountName -Force | Select-Object -Expand ContentUri
# Create a Policy Id
$PolicyId = $(New-GUID)
# Define the parameters to create and publish the guest configuration policy
$Params = @{
  "PolicyId" =  $PolicyId
  "ContentUri" =  $ContentURI
  "DisplayName" =  'ISO 1337'
  "Description" =  'Make sure all servers comply with ISO 1337'
  "Path" =  './policies'
  "Platform" =  'Windows'
  "Version" =  '1.0.1'
  "Mode" =  'ApplyAndAutoCorrect'
  "Verbose" = $true
}
# Create the guest configuration policy
New-GuestConfigurationPolicy @Params
# Publish the guest configuration policy
Publish-GuestConfigurationPolicy -Path './policies'
