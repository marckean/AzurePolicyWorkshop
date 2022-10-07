Configuration CreateAdminUser
{
    param (
        [System.Management.Automation.PSCredential]
        $PasswordCredential
    )

    Import-DscResource -ModuleName 'PSDscResources'

    node localhost
    {
        User AdminUser {
            Ensure   = 'Present'
            UserName = 'MyTestAdminUser'
            Password = $PasswordCredential
        }


        GroupSet AddUserToAdminGroup {
            GroupName        = @( 'Administrators' )
            Ensure           = 'Present'
            MembersToInclude = @( 'MyTestAdminUser' )
# https://github.com/dsccommunity/xPSDesiredStateConfiguration/issues/400            
#            DependsOn        = '[User]AdminUser'
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName                    = 'localhost'
            PSDscAllowPlainTextPassword = $true
        }
    )
}

$Credentials = Get-Credential -UserName MyTestAdminUser

CreateAdminUser -PasswordCredential $Credentials -ConfigurationData $ConfigurationData -OutputPath ".\06 Deployment of Guest Config Policies\01 dscConfig_files"
