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
