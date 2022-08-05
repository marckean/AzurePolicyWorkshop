param location string = resourceGroup().location

var securityRules = [
  {
    name: 'Allow_RDP1-S'
    description: 'Allow RDP'
    protocol: '*'
    sourcePortRange: '3389'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'

  }
  {
    name: 'Allow_RDP3-S'
    description: 'Allow RDP'
    protocol: '*'
    sourcePortRange: '3380-3389'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 120
    direction: 'Inbound'
  }
  {
    name: 'Allow_RDP4-D'
    description: 'Allow RDP'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '3380-3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 130
    direction: 'Inbound'
  }
  {
    name: 'Allow_RDP6-D'
    description: 'Allow RDP'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 150
    direction: 'Inbound'
  }
  {
    name: 'Allow_RDP7-D'
    description: 'Allow RDP'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '164.97.246.192'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 160
    direction: 'Inbound'
  }
  {
    name: 'Allow_RDP8-D'
    description: 'Allow RDP'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '164.97.246.192/28'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 170
    direction: 'Inbound'
  }
  {
    name: 'Allow_SSH1-S'
    description: 'Allow SSH'
    protocol: '*'
    sourcePortRange: '22'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 200
    direction: 'Inbound'
  }
  {
    name: 'Allow_SSH3-S'
    description: 'Allow SSH'
    protocol: '*'
    sourcePortRange: '20-22'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 220
    direction: 'Inbound'
  }
  {
    name: 'Allow_SSH4-D'
    description: 'Allow SSH'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '20-22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 230
    direction: 'Inbound'
  }
  {
    name: 'Allow_SSH6-D'
    description: 'Allow SSH'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 250
    direction: 'Inbound'
  }
  {
    name: 'Allow_SSH7-D'
    description: 'Allow SSH'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '164.97.246.192'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 260
    direction: 'Inbound'
  }
  {
    name: 'Allow_SSH8-D'
    description: 'Allow SSH'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '164.97.246.192/28'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 270
    direction: 'Inbound'
  }
  {
    name: 'Allow_RDP2-S'
    description: 'Allow RDP'
    protocol: '*'
    sourcePortRanges: [
      '3380'
      '3389'
    ]
    destinationPortRange: '3380-3389'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 110
    direction: 'Inbound'

  }
  {
    name: 'Allow_SSH2-S'
    description: 'Allow SSH'
    protocol: '*'
    sourcePortRanges: [
      '21'
      '22'
    ]
    destinationPortRange: '21-22'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 210
    direction: 'Inbound'
  }
  {
    name: 'Allow_RDP5-D'
    description: 'Allow RDP'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRanges: [
      '3380'
      '3389'
    ]
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 140
    direction: 'Inbound'
  }
  {
    name: 'Allow_SSH5-D'
    description: 'Allow SSH'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRanges: [
      '21'
      '22'
    ]
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 240
    direction: 'Inbound'
  }
]

resource nsg1 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: 'nsg1'
  location: location
  properties: {}
}

resource nsgrules1 'Microsoft.Network/networkSecurityGroups/securityRules@2021-08-01' = [for rule in securityRules: {
  name: rule.name
  parent: nsg1
  properties: {
    description: contains(rule, 'description') ? rule.description : ''
    direction: contains(rule, 'direction') ? rule.direction : ''
    protocol: contains(rule, 'protocol') ? rule.protocol : ''
    access: contains(rule, 'access') ? rule.access : ''
    destinationPortRange: contains(rule, 'destinationPortRange') ? rule.destinationPortRange : ''
    destinationPortRanges: contains(rule, 'destinationPortRanges') ? rule.destinationPortRanges : []
    sourcePortRange: contains(rule, 'sourcePortRange') ? rule.sourcePortRange : ''
    sourcePortRanges: contains(rule, 'sourcePortRanges') ? rule.sourcePortRanges : []
    destinationAddressPrefix: contains(rule, 'destinationAddressPrefix') ? rule.destinationAddressPrefix : ''
    sourceAddressPrefix: contains(rule, 'sourceAddressPrefix') ? rule.sourceAddressPrefix : ''
    priority: contains(rule, 'priority') ? rule.priority : ''
  }
}]

output nsg string = nsg1.id
