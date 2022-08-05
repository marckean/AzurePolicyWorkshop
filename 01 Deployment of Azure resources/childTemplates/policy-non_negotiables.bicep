targetScope = 'managementGroup'


// 
resource Non_Negotiables_Initiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: 'Non_Negotiables'
  properties: {
    displayName: ''
    description: 'A group of all Non_Negotiable Polich Definitions for Aus Govt. Agencies'
    metadata: {
      category: 'Custom'
    }
    policyDefinitions: [
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
        policyDefinitionReferenceId: 'Audit requirement of Secure transfer in your storage account. Secure transfer is an option that forces your storage account to accept requests only from secure connections (HTTPS). Use of HTTPS ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking'
        parameters: {
          Effect: {
            value: 'australiaeast'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e3576e28-8b17-4677-84c3-db2990658d64'
        policyDefinitionReferenceId: 'All network ports should be restricted on network security groups associated to your virtual machine'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/5e1cd26a-5090-4fdb-9d6a-84a90335e22d'
        policyDefinitionReferenceId: 'AUE - Configure network security groups to use specific workspace for traffic analytics'
        parameters: {
          nsgRegion: {
            value: 'australiaeast'
          }
          storageId: {
            value: '/subscriptions/5bf747d8-aeef-42a9-9263-07379c144d5a/resourceGroups/secgovdemoaue/providers/Microsoft.Storage/storageAccounts/secgovdemoauetest'
          }
          workspaceResourceId: {
            value: '/subscriptions/5bf747d8-aeef-42a9-9263-07379c144d5a/resourceGroups/secgovdemoaue/providers/Microsoft.OperationalInsights/workspaces/secgovdemoaue'
          }
          workspaceRegion: {
            value: 'australiaeast'
          }
          workspaceId: {
            value: 'dbdc3853-90df-4cb4-8e5d-274cf783a0d6'
          }
          networkWatcherRG: {
            value: 'NetworkWatcherRG'
          }
          networkWatcherName: {
            value: 'NetworkWatcher_australiaeast'
          }
        }
      }
    ]
  }
}

resource Non_Negotiables_Policy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: ''
  properties: {
    description: ''
    displayName: ''
    metadata: {

    }
    parameters: {

    }
    mode:
    policyRule: {
      
    }
    policyType: 'Custom'
  }

  
}

resource dinePolicy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'test'
  properties: {
    policyType: 'Custom'
    policyRule: {
      if: {
        // ...
      }
      then: {
        effect: 'DeployIfNotExists'
        details: {
          type: ''
          name: ''
          roleDefinitionIds: [
            // ...
          ]
          existenceCondition: {
            // ...
          }
          deployment: {
            properties: {
              mode: 'Incremental'
              template: {
                '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                resources: [
                  {
                    type: '...'
                    apiVersion: '...'
                    name: '...'
                    properties: {}
                  }
                ]
              }
            }
          }
        }
      }
    }
  }
}

// RESOURCES
resource bicepExampleDINEpolicy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'bicepExampleDINEpolicy'
  properties: {
    displayName: 'DINE metric alert to Load Balancer for dipAvailability'
    description: 'DeployIfNotExists a metric alert to Load Balancers for dipAvailability (Average Load Balancer health probe status per time duration)'
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: policyDefCategory
      source: policySource
      version: '0.1.0'
    }
    parameters: {}
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: metricAlertResourceNamespace
          }
          {
            field: 'Microsoft.Network/loadBalancers/sku.name'
            equals: 'Standard' // only Standard SKU support metric alerts
          }
        ]
      }
      then: {
        effect: 'deployIfNotExists'
        details: {
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // contributor RBAC role for deployIfNotExists effect
          ]
          type: 'Microsoft.Insights/metricAlerts'
          existenceCondition: {
            allOf: [
              {
                field: 'Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace'
                equals: metricAlertResourceNamespace
              }
              {
                field: 'Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName'
                equals: metricAlertName
              }
              {
                field: 'Microsoft.Insights/metricalerts/scopes[*]'
                equals: '[concat(subscription().id, \'/resourceGroups/\', resourceGroup().name, \'/providers/${metricAlertResourceNamespace}/\', field(\'fullName\'))]'
              }
            ]
          }
          deployment: {
            properties: {
              mode: 'incremental'
              template: {
                '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                parameters: {
                  resourceName: {
                    type: 'String'
                    metadata: {
                      displayName: 'resourceName'
                      description: 'Name of the resource'
                    }
                  }
                  resourceId: {
                    type: 'String'
                    metadata: {
                      displayName: 'resourceId'
                      description: 'Resource ID of the resource emitting the metric that will be used for the comparison'
                    }
                  }
                  resourceLocation: {
                    type: 'String'
                    metadata: {
                      displayName: 'resourceLocation'
                      description: 'Location of the resource'
                    }
                  }
                  actionGroupName: {
                    type: 'String'
                    metadata: {
                      displayName: 'actionGroupName'
                      description: 'Name of the Action Group'
                    }
                  }
                  actionGroupRG: {
                    type: 'String'
                    metadata: {
                      displayName: 'actionGroupRG'
                      description: 'Resource Group containing the Action Group'
                    }
                  }
                  actionGroupId: {
                    type: 'String'
                    metadata: {
                      displayName: 'actionGroupId'
                      description: 'The ID of the action group that is triggered when the alert is activated or deactivated'
                    }
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.Insights/metricAlerts'
                    apiVersion: '2018-03-01'
                    name: '[concat(parameters(\'resourceName\'), \'-${metricAlertName}\')]'
                    location: 'global'
                    properties: {
                      description: metricAlertDescription
                      severity: metricAlertSeverity
                      enabled: metricAlertEnabled
                      scopes: [
                        '[parameters(\'resourceId\')]'
                      ]
                      evaluationFrequency: metricAlertEvaluationFrequency
                      windowSize: metricAlertWindowSize
                      criteria: {
                        allOf: [
                          {
                            alertSensitivity: metricAlertSensitivity
                            failingPeriods: {
                              numberOfEvaluationPeriods: '2'
                              minFailingPeriodsToAlert: '1'
                            }
                            name: 'Metric1'
                            metricNamespace: metricAlertResourceNamespace
                            metricName: metricAlertName
                            dimensions: [
                              {
                                name: metricAlertDimension1
                                operator: 'Include'
                                values: [
                                  '*'
                                ]
                              }
                              {
                                name: metricAlertDimension2
                                operator: 'Include'
                                values: [
                                  '*'
                                ]
                              }
                              {
                                name: metricAlertDimension3
                                operator: 'Include'
                                values: [
                                  '*'
                                ]
                              }
                            ]
                            operator: metricAlertOperator
                            timeAggregation: metricAlertTimeAggregation
                            criterionType: metricAlertCriterionType
                          }
                        ]
                        'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
                      }
                      autoMitigate: metricAlertAutoMitigate
                      targetResourceType: metricAlertResourceNamespace
                      targetResourceRegion: '[parameters(\'resourceLocation\')]'
                      actions: [
                        {
                          actionGroupId: actionGroupId
                          webHookProperties: {}
                        }
                      ]
                    }
                  }
                ]
              }
              parameters: {
                resourceName: {
                  value: '[field(\'name\')]'
                }
                resourceId: {
                  value: '[field(\'id\')]'
                }
                resourceLocation: {
                  value: '[field(\'location\')]'
                }
                actionGroupName: {
                  value: actionGroupName
                }
                actionGroupRG: {
                  value: actionGroupRG
                }
                actionGroupID: {
                  value: actionGroupId
                }
              }
            }
          }
        }
      }
    }
  }
}


resource Non_Negotiables_Assignments 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'australiaeast'
  location: 'australiaeast'
  properties: {
    description: ''
    displayName: '00'
    enforcementMode: ''
    nonComplianceMessages: [
      {
        message: 'You idiot, what were you thinking?'
      }
    ]
    parameters: {
      
    }
  }
}
