. './01 variables/variables.ps1' # Dot Source the variables

# Create a package that will audit and apply the configuration (Set)
New-GuestConfigurationPackage `
-Name "$($variables.gcStorageBlobName).zip" `
-Configuration '.\06 Deployment of Guest Config Policies\01 dscConfig_files\MyConfig.mof' `
-Type AuditAndSet `
-Path '.\06 Deployment of Guest Config Policies\02 GuestConfigPackage' `
-Force

