targetScope = 'managementGroup'
@secure()
param secret_vm_password string = ''

param vm_username string = ''

// Tenant
var subscriptionID = '7ac51792-8ea1-4ea8-be56-eb515e42aadf'
var tenantID = '8efecb12-cbaa-4612-b850-e6a68c14d336'
var ManagemantGroup = 'Test'

// Resource Groups
var resourceGroups_var = [
  {
    name: 'Company_RG_01'
    location: 'australiaeast'
    resourceGroupName: 'Company_Identity'
  }
  {
    name: 'Company_RG_02'
    location: 'australiaeast'
    resourceGroupName: 'Company_PaaS'
  }
  {
    name: 'Company_RG_03'
    location: 'australiaeast'
    resourceGroupName: 'Company_IaaS'
  }
  {
    name: 'Company_RG_04'
    location: 'australiaeast'
    resourceGroupName: 'Company_Network'
  }
  {
    name: 'Company_RG_05'
    location: 'australiaeast'
    resourceGroupName: 'Company_Storage'
  }
  {
    name: 'Company_RG_06'
    location: 'australiaeast'
    resourceGroupName: 'Company_Open'
  }
]

// Virtual Networks
var virtualNetworks_var = [
  {
    name: 'Company_VirtualNetwork_01'
    virtualNetworkName: 'Company_vNet_01'
    addressSpace_addressPrefixes: [
      '10.3.0.0/16'
    ]
    subnets_var: [
      {
        name: 'Company_Subnet_01'
        subnetName: 'First'
        virtualNetworkName: 'Company_VirtualNetwork_01'
        privateEndpointNetworkPolicies: 'Enabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
        addressPrefix: '10.3.0.0/24'
      }
      {
        name: 'Company_Subnet_02'
        subnetName: 'AzureBastionSubnet'
        virtualNetworkName: 'Company_VirtualNetwork_01'
        privateEndpointNetworkPolicies: 'Enabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
        addressPrefix: '10.3.250.0/26'
      }
    ]
  }
]

// Network Interface Cards
var nics_var = [
  {
    name: 'Company_NIC_01'
    virtualNetworkName: virtualNetworks_var[0].virtualNetworkName
    subnetName: virtualNetworks_var[0].subnets_var[0].subnetName
    networkInterfaceName: 'LA-Test-DCR-01-NIC'
  }
  {
    name: 'Company_NIC_02'
    virtualNetworkName: virtualNetworks_var[0].virtualNetworkName
    subnetName: virtualNetworks_var[0].subnets_var[0].subnetName
    networkInterfaceName: 'LA-Test-DCR-02-NIC'
  }
]

// Virtual Machines
var virtualMachine_var = [
  {
    name: 'Company_VirtualMachine_01'
    virtualMachineName: 'LA-Test-DCR-01'
    networkInterfaceName: nics_var[0].networkInterfaceName
    networkInterfaceResourceGroupName: resourceGroups_var[3].resourceGroupName
    adminUsername: vm_username
    adminPassword: secret_vm_password
    virtualMachineSize: 'Standard_B2ms'
  }
  {
    name: 'Company_VirtualMachine_02'
    virtualMachineName: 'LA-Test-DCR-02'
    networkInterfaceName: nics_var[1].networkInterfaceName
    networkInterfaceResourceGroupName: resourceGroups_var[3].resourceGroupName
    adminUsername: vm_username
    adminPassword: secret_vm_password
    virtualMachineSize: 'Standard_B2ms'
  }
]

//Storage
var globalRedundancy = false
var storageSku = globalRedundancy ? 'Standard_GRS' : 'Standard_LRS' // if true --> GRS, else --> LRS
var storageAccounts = [
  {
    name: 'Company_StorageAccount_wrong'
    storageAccountNamePrefex: 'wrong'
    minimumTlsVersion: 'TLS1_0'
    supportsHttpsTrafficOnly: false
    allowBlobPublicAccess: true
  }
  {
    name: 'Company_StorageAccount_right'
    storageAccountNamePrefex: 'right'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
  }
]

//https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-to-management-group?tabs=azure-cli

// Subscription scope
module resourceGroupModule '../childTemplates/resource-group.bicep' = [for RG in resourceGroups_var: {
  name: RG.name
  scope: subscription(subscriptionID)
  params: {
    location: RG.location
    RG_name: RG.resourceGroupName
  }
}]

// Subscription scope

// Resource Group scope
module storageAcct '../childTemplates/storage-account.bicep' = [for storageAccount in storageAccounts: {
  name: storageAccount.name
  scope: resourceGroup(subscriptionID, resourceGroups_var[4].resourceGroupName)
  params: {
    location: resourceGroupModule[0].outputs.RGLocation
    storageAccountNamePrefex: storageAccount.storageAccountNamePrefex
    minimumTlsVersion: storageAccount.minimumTlsVersion
    supportsHttpsTrafficOnly: storageAccount.supportsHttpsTrafficOnly
    allowBlobPublicAccess: storageAccount.allowBlobPublicAccess
    storageSku: storageSku

  }
  dependsOn: [
    resourceGroupModule
  ]
}]

// Resource Group scope
module userAssignedIdentity_01 '../childTemplates/userAssignedIdentity.bicep' = {
  name: 'Company_userAssignedIdentity_01'
  scope: resourceGroup(subscriptionID, resourceGroups_var[0].resourceGroupName)
  params: {
    managedIdentityName: 'AzurePolicy_ID'
    location: resourceGroupModule[0].outputs.RGLocation
  }
}

// Resource Group scope
module userAssignedIdentity_02 '../childTemplates/userAssignedIdentity.bicep' = {
  name: 'Company_userAssignedIdentity_02'
  scope: resourceGroup(subscriptionID, resourceGroups_var[0].resourceGroupName)
  params: {
    managedIdentityName: 'AzureKeyVault_ID'
    location: resourceGroupModule[0].outputs.RGLocation
  }
}

// Resource Group scope
module nsg1 '../childTemplates/nsg_rules.bicep' = {
  scope: resourceGroup(subscriptionID, resourceGroups_var[3].resourceGroupName)
  name: 'Company_NSG_01'
  params: {
    location: resourceGroupModule[0].outputs.RGLocation
  }
  dependsOn: [
    resourceGroupModule
  ]
}

// Resource Group scope
module kv1 '../childTemplates/KeyVault.bicep' = {
  scope: resourceGroup(subscriptionID, resourceGroups_var[1].resourceGroupName)
  name: 'Company_KeyVault_01'
  params: {
    location: resourceGroupModule[0].outputs.RGLocation
    tenantID: tenantID
    objectID: userAssignedIdentity_02.outputs.principalId
  }
  dependsOn: [
    resourceGroupModule
  ]
}

// Resource Group scope
module la1 '../childTemplates/log-analytics.bicep' = {
  scope: resourceGroup(subscriptionID, resourceGroups_var[1].resourceGroupName)
  name: 'Company_LogAnalytics_01'
  params: {
    location: resourceGroupModule[0].outputs.RGLocation
  }
  dependsOn: [
    resourceGroupModule
  ]
}

// Subscription Group scope
module pa1 '../childTemplates/policy_assignments.bicep' = {
  //scope: subscription(subscriptionID)
  scope: resourceGroup(subscriptionID, resourceGroups_var[2].resourceGroupName)
  name: 'Company_PolicyAssignment_01'
  params: {
    location: resourceGroupModule[0].outputs.RGLocation
    DCR_ResourceGroupName: resourceGroups_var[1].resourceGroupName
  }
}

// Resource Group scope
module virtual_Network_with_subnet_Module '../childTemplates/virtual_network_with_subnet.bicep' = [for virtualNetwork in virtualNetworks_var: {
  scope: resourceGroup(subscriptionID, resourceGroups_var[3].resourceGroupName)
  name: virtualNetwork.name
  params: {
    location: resourceGroups_var[3].location
    virtualNetworkName: virtualNetwork.virtualNetworkName
    addressSpace_addressPrefixes: virtualNetwork.addressSpace_addressPrefixes
    subnets: virtualNetwork.subnets_var
  }
  dependsOn: [
    resourceGroupModule
  ]
}]

// Resource Group scope
module nic_module '../childTemplates/network_interface_card.bicep' = [for nic in nics_var: {
  scope: resourceGroup(subscriptionID, resourceGroups_var[3].resourceGroupName)
  name: nic.name
  params: {
    location: resourceGroups_var[3].location
    virtualNetworkName: nic.virtualNetworkName
    subnetName: nic.subnetName
    networkInterfaceName: nic.networkInterfaceName
  }
  dependsOn: [
    resourceGroupModule
    virtual_Network_with_subnet_Module
  ]
}]

// Resource Group scope
module virtualMachine_module '../childTemplates/virtual_machine.bicep' = [for virtualMachine in virtualMachine_var: {
  scope: resourceGroup(subscriptionID, resourceGroups_var[2].resourceGroupName)
  name: virtualMachine.name
  params: {
    location: resourceGroups_var[0].location
    virtualMachineName: virtualMachine.virtualMachineName
    networkInterfaceName: virtualMachine.networkInterfaceName
    networkInterfaceResourceGroupName: virtualMachine.networkInterfaceResourceGroupName
    adminUsername: virtualMachine.adminUsername
    adminPassword: virtualMachine.adminPassword
    virtualMachineSize: virtualMachine.virtualMachineSize
  }
  dependsOn: [
    nic_module
  ]
}]

// Resource Group scope
module PIP_module '../childTemplates/public_IP_address.bicep' = {
  scope: resourceGroup(subscriptionID, resourceGroups_var[3].resourceGroupName)
  name: 'Company_BastionPIP_01'
  params: {
    location: resourceGroups_var[0].location
    name: 'Company_PIP'
  }
  dependsOn: [
    resourceGroupModule
  ]
}

// Resource Group scope
module bastion_01 '../childTemplates/bastion.bicep' = {
  scope: resourceGroup(subscriptionID, resourceGroups_var[3].resourceGroupName)
  name: 'Company_Bastion_01'
  params: {
    location: resourceGroups_var[0].location
    bastionName: 'Company_Bastion'
    virtualNetworkName: virtualNetworks_var[0].virtualNetworkName
    azureBastionPublicIpName: PIP_module.outputs.name
  }
  dependsOn: [
    resourceGroupModule
    virtual_Network_with_subnet_Module
  ]
}
