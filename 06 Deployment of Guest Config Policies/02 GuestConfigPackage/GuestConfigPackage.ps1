. './01 variables/variables.ps1' # Dot Source the variables

# Create a package that will audit and apply the configuration (Set)
# Will create a MyConfig.zip file
New-GuestConfigurationPackage `
-Name "$($variables.gcStorageBlobName)" `
-Configuration '.\06 Deployment of Guest Config Policies\01 dscConfig_files\localhost.mof' `
-Type AuditAndSet `
-Path '.\06 Deployment of Guest Config Policies\02 GuestConfigPackage' `
-Force

