param location string = resourceGroup().location

resource nsg1 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
    name: 'nsg_with_22_3389_rules'
    location: location
    properties: {
        securityRules: [ //Rules cannot have the same Priority and Direction
            {
                name: 'Allow_RDP1-S'
                properties: {
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
            }
            {
                name: 'Allow_RDP2-S'
                properties: {
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
            }
            {
                name: 'Allow_RDP3-S'
                properties: {
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
            }
            {
                name: 'Allow_RDP4-D'
                properties: {
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
            }
            {
                name: 'Allow_RDP5-D'
                properties: {
                    description: 'Allow RDP'
                    protocol: '*'
                    sourcePortRange: '*'
                    destinationPortRanges:[
                        '3380'
                        '3389'
                    ]
                    sourceAddressPrefix: '*'
                    destinationAddressPrefix: '*'
                    access: 'Allow'
                    priority: 140
                    direction: 'Inbound'
                }
            }
            {
                name: 'Allow_RDP6-D'
                properties: {
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
            }
            {
                name: 'Allow_RDP7-D'
                properties: {
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
            }
            {
                name: 'Allow_RDP8-D'
                properties: {
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
            }
            {
                name: 'Allow_SSH1-S'
                properties: {
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
            }
            {
                name: 'Allow_SSH2-S'
                properties: {
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
            }
            {
                name: 'Allow_SSH3-S'
                properties: {
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
            }
            {
                name: 'Allow_SSH4-D'
                properties: {
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
            }
            {
                name: 'Allow_SSH5-D'
                properties: {
                    description: 'Allow SSH'
                    protocol: '*'
                    sourcePortRange: '*'
                    destinationPortRanges:[
                        '21'
                        '22'
                    ]
                    sourceAddressPrefix: '*'
                    destinationAddressPrefix: '*'
                    access: 'Allow'
                    priority: 240
                    direction: 'Inbound'
                }
            }
            {
                name: 'Allow_SSH6-D'
                properties: {
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
            }
            {
                name: 'Allow_SSH7-D'
                properties: {
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
            }
            {
                name: 'Allow_SSH8-D'
                properties: {
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
            }
        ]
    }
}

output nsg string = nsg1.id
