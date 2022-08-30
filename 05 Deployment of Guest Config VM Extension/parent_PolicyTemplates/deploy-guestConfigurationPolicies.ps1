$TimeNow = Get-Date -Format yyyyMMdd-hhmm

New-AzResourceGroupDeployment -ResourceGroupName 'Company_IaaS' -TemplateFile '.\05 Deployment of Guest Config VM Extension\child_PolicyTemplates\policyAssignments.json' -Name $TimeNow -Verbose -ErrorAction Continue






#--------------------------------------------
# Testing - DO NOT RUN
#--------------------------------------------
$lastDeploymentName = (Get-AzSubscriptionDeployment | where {$_.ProvisioningState -ne 'Succeeded'} | sort Timestamp -Descending)[0].DeploymentName
if($lastDeploymentName){Remove-AzSubscriptionDeployment -Name $lastDeploymentName}


