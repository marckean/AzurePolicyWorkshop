# Sign-in
Connect-AzAccount

. './01 variables/variables.ps1' # Dot Source the variables

Get-AzSubscription
Set-AzContext -SubscriptionId $variables.subscription_id

$TimeNow = Get-Date -Format yyyyMMdd-hhmm

$paramObject = @{
    'RG_name' = 'Company_NSG'
    'location' = $variables.location
    'subscriptionID' = $variables.subscription_id
  }

# NSGs with the Security Rules as sub-resources
New-AzManagementGroupDeployment -Location $variables.location -TemplateFile './02 Testing Azure Policies\parentTemplates\main(nsg).bicep' -ManagementGroupId $variables.ManagementGroupId -TemplateParameterObject $paramObject -Name $TimeNow -Verbose