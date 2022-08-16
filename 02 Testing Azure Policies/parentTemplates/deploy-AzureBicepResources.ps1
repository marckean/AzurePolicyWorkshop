# Sign-in
Connect-AzAccount

Get-AzSubscription
Set-AzContext -SubscriptionId '7ac51792-8ea1-4ea8-be56-eb515e42aadf'

$ManagementGroupId = "TEST" # this is the root Management Group ID
$location = "australiaeast"

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

# NSGs with the Security Rules as sub-resources
New-AzManagementGroupDeployment -Location $location -TemplateFile './02 Testing Azure Policies\parentTemplates\main(nsg).bicep' -ManagementGroupId $ManagementGroupId -Name $TimeNow -Verbose