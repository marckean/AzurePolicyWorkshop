# Create a package that will audit and apply the configuration (Set)
New-GuestConfigurationPackage `
-Name 'MyConfig' `
-Configuration '.\04 Deployment of Guest Config Policies\dscConfig_files\MyConfig.mof' `
-Type AuditAndSet `
-Force
