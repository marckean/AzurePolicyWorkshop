# Create a package that will audit and apply the configuration (Set)
New-GuestConfigurationPackage `
-Name 'MyConfig' `
-Configuration '.\04 Deployment of Guest Config Policies\01 dscConfig_files\localhost.mof' `
-Type AuditAndSet `
-Path '.\04 Deployment of Guest Config Policies\02 GuestConfigPackage'
-Force