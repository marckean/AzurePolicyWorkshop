#----------------------------------------------------------------------
# On-demand evaluation scan - Azure PowerShell
# https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#on-demand-evaluation-scan---azure-powershell
#----------------------------------------------------------------------

# By default, Start-AzPolicyComplianceScan starts an evaluation for all resources in the current subscription. To start an evaluation on a specific resource group, use the ResourceGroupName parameter.
# The following example starts a compliance scan in the current subscription for the MyRG resource group:

Start-AzPolicyComplianceScan -ResourceGroupName 'Company-IaaS'

$job = Start-AzPolicyComplianceScan -ResourceGroupName 'Company-IaaS' -AsJob

$job | Format-List Name, Command, StatusMessage, JobStateInfo, PSBeginTime, PSEndTime, State