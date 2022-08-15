Configuration Main
{

#Import-DscResource -Name 'xRemoteFile' -ModuleName '.\xPSDesiredStateConfiguration'
<# xPSDesiredStateConfiguration containes….
xDscWebService, xWindowsProcess, xService, xPackage
xArchive, xRemoteFile, xPSEndpoint, xWindowsOptionalFeature
#>

$SourceFiles = "$env:SystemDrive\SourceFiles"

Node $env:COMPUTERNAME
  {
    File SourceFiles 
    {
        DestinationPath = $SourceFiles
        Ensure = 'Present'
        Type = 'Directory'
    }

################################################################################
##################     Packages, Software Installation
################################################################################
#region Packages
    Package InstallAzCopy
    {
        Ensure = "Present"
        Path  = "$SourceFiles\MicrosoftAzureStorageTools.msi"
        Name = "Microsoft Azure Storage Tools – v6.1.0"
        ProductId = "{1D24B7AC-AFB4-44D4-928B-5CB14ABF4839}"
        #Arguments = "ADDLOCAL=ALL"
        DependsOn = "[Script]DownloadAzCopy"
    }
#endregion

################################################################################
##################     Windows Features
################################################################################
#region Windows Features
    foreach ($Feature in @("Web-Server","Web-Common-Http","Web-Static-Content", ` 
            "Web-Default-Doc","Web-Dir-Browsing","Web-Http-Errors",` 
            "Web-Health","Web-Http-Logging","Web-Log-Libraries",` 
            "Web-Request-Monitor","Web-Security","Web-Filtering",`
            "Web-Stat-Compression","Web-Http-Redirect","Web-Mgmt-Tools",`
            "WAS","WAS-Process-Model","WAS-NET-Environment","WAS-Config-APIs","Web-CGI"))
        {
    WindowsFeature $Feature
    {
      Name = $Feature
      Ensure = "Present"
    }
}
#endregion

################################################################################
##################     Scripts
################################################################################
#region Scripts

   Script DownloadAzCopy
    {
        TestScript = { # the TestScript block runs first. If the TestScript block returns $false, the SetScript block will run
            Test-Path "$using:SourceFiles\MicrosoftAzureStorageTools.msi"
        }
        SetScript = {
            $source = "$using:PublicStorageSourceContainer/AzCopy/MicrosoftAzureStorageTools.msi"
            $dest = "$using:SourceFiles\MicrosoftAzureStorageTools.msi"
            Invoke-WebRequest $source –OutFile $dest
        }
		GetScript = { # should return a hashtable representing the state of the current node
            $result = Test-Path "$using:SourceFiles\MicrosoftAzureStorageTools.msi"
			@{
				"Downloaded" = $result
			}
		}
        DependsOn = "[File]SourceFiles"
    }

	# Disable Password Complexity
    Script DisablePasswordComplexity
	{
        TestScript = { # the TestScript block runs first. If the TestScript block returns $false, the SetScript block will run
            $null = secedit /export /cfg $env:USERPROFILE\secpol.cfg
			$null = (Get-Content $env:USERPROFILE\secpol.cfg) | ? {$_ -match 'PasswordComplexity.=.(.)'}
			$null = Remove-Item –force $env:USERPROFILE\secpol.cfg –confirm:$false
			# make sure PasswordComplexity is set to '0'
			$Matches[1] -eq '0'
        }
        SetScript = {
            # Disable Password Complexity
			secedit /export /cfg $env:USERPROFILE\secpol.cfg
			(gc $env:USERPROFILE\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File $env:USERPROFILE\secpol.cfg
			secedit /configure /db c:\windows\security\local.sdb /cfg $env:USERPROFILE\secpol.cfg /areas SECURITYPOLICY
			Remove-Item –force $env:USERPROFILE\secpol.cfg –confirm:$false
        }
		GetScript = { # should return a hashtable representing the state of the current node
            $null = secedit /export /cfg $env:USERPROFILE\secpol.cfg
			$null = (Get-Content $env:USERPROFILE\secpol.cfg) | ? {$_ -match 'PasswordComplexity.=.(.)'}
			$null = Remove-Item –force $env:USERPROFILE\secpol.cfg –confirm:$false
			
			@{
				"PasswordComplexity" = $Matches[1]
			}
		}
    }


#endregion

################################################################################
##################     Registry Stuff
################################################################################
#region Registry Stuff
	Registry ExecutionPolicy 
	{
        Ensure = 'Present'
        Key = 'HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell\'
        ValueName = 'ExecutionPolicy'
        ValueData = 'Unrestricted'
        ValueType = "String"
    }
#endregion

  }
}

Main -OutputPath ".\04 Deployment of Guest Config Policies\01 dscConfig_files"

Install-Module -Name GuestConfiguration -Scope CurrentUser -Repository PSGallery -Force