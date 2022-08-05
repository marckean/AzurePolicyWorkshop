param location string = resourceGroup().location
param ParentLAWorkspaceName string = 'la-parent${uniqueString(resourceGroup().id)}'
param ChildLAWorkspaceNam01 string = 'la-child-01${uniqueString(resourceGroup().id)}'

var environmentName = 'Test'
var costCenterName = 'IT'

resource LA_Parent 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: ParentLAWorkspaceName
  location: location
  tags: {
    Environment: environmentName
    CostCenter: costCenterName
  }
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource LA_Child01 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: ChildLAWorkspaceNam01
  location: location
  tags: {
    Environment: environmentName
    CostCenter: costCenterName
  }
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource DCR_AllSystemInformation 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'DCR-AllSystemInformation'
  kind: 'Windows'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            '*[System[(Level=4 or Level=0)]]'
          ]
          name: 'AllSystemInformation'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: LA_Child01.id
          name: LA_Child01.name
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          LA_Child01.name
        ]
      }
    ]
  }
}

resource DCR_AllSystemCritical 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'DCR-AllSystemCritical'
  kind: 'Windows'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            '*[System[(Level=1)]]'
          ]
          name: 'AllSystemCritical'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: LA_Child01.id
          name: LA_Child01.name
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          LA_Child01.name
        ]
      }
    ]
  }
}

resource DCR_AccountLockoutEvents 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'DCR-AccountLockoutEvents'
  kind: 'Windows'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Security!*[System[((EventID=4625))]]'
            'Security!*[System[((EventID=4740))]]'
          ]
          name: 'AccountLockoutEvents'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: LA_Child01.id
          name: LA_Child01.name
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          LA_Child01.name
        ]
      }
    ]
  }
}

resource DCR_ASREvents 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'DCR-ASREvents'
  kind: 'Windows'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Microsoft-Windows-Windows Defender/Operational!*[System[((EventID &gt;= 1121 and EventID &lt;= 1122))]]'
            'Microsoft-Windows-Windows Defender/WHC!*[System[((EventID &gt;= 1121 and EventID &lt;= 1122))]]'
          ]
          name: 'ASREvents'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: LA_Child01.id
          name: LA_Child01.name
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          LA_Child01.name
        ]
      }
    ]
  }
}

resource DCR_NTLMEvents 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'DCR-NTLMEvents'
  kind: 'Windows'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Microsoft-Windows-NTLM/Operational!*[System[((EventID &gt;= 8001 and EventID &lt;= 8004))]]'
          ]
          name: 'NTLMEvents'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: LA_Child01.id
          name: LA_Child01.name
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          LA_Child01.name
        ]
      }
    ]
  }
}

resource DCR_ExploitProtectionEvents 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'DCR-ExploitProtectionEvents'
  kind: 'Windows'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Microsoft-Windows-Security-Mitigations/KernelMode!*[System[((EventID &gt;= 1 and EventID &lt;= 24))]]'
            'Microsoft-Windows-Security-Mitigations/UserMode!*[System[((EventID &gt;= 1 and EventID &lt;= 24))]]'
            'Microsoft-Windows-Win32k/Operational!*[System[((EventID=260))]]'
            'System!*[System[Provider[@Name=\'Microsoft-Windows-WER-Diag\'] and (EventID=5)]]'
          ]
          name: 'ExploitProtectionEvents'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: LA_Child01.id
          name: LA_Child01.name
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          LA_Child01.name
        ]
      }
    ]
  }
}

resource DCR_IPsecEvents 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'DCR-IPsecEvents'
  kind: 'Windows'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Security!*[System[((EventID &gt;= 4650 and EventID &lt;= 4651))]]'
            'Security!*[System[((EventID=5451))]]'
          ]
          name: 'IPsecEvents'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: LA_Child01.id
          name: LA_Child01.name
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          LA_Child01.name
        ]
      }
    ]
  }
}

resource DCR_NetworkProtectionEvents 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'DCR-NetworkProtectionEvents'
  kind: 'Windows'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Microsoft-Windows-Windows Defender/Operational!*[System[((EventID &gt;= 1125 and EventID &lt;= 1126))]]'
            'Microsoft-Windows-Windows Defender/WHC!*[System[((EventID &gt;= 1125 and EventID &lt;= 1126))]]'
          ]
          name: 'NetworkProtectionEvents'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: LA_Child01.id
          name: LA_Child01.name
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          LA_Child01.name
        ]
      }
    ]
  }
}

resource DCR_SChannelEvents 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'DCR-SChannelEvents'
  kind: 'Windows'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'System!*[System[((EventID=36880))]]'
          ]
          name: 'SChannelEvents'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: LA_Child01.id
          name: LA_Child01.name
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          LA_Child01.name
        ]
      }
    ]
  }
}

resource DCR_WDACEvents 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'DCR-WDACEvents'
  kind: 'Windows'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Microsoft-Windows-CodeIntegrity/Operational!*[System[((EventID=3077 or EventID=3092 or EventID=3099))]]'
          ]
          name: 'WDACEvents'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: LA_Child01.id
          name: LA_Child01.name
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          LA_Child01.name
        ]
      }
    ]
  }
}

output storageId string = LA_Parent.id
