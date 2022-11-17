/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location

module justAccount '../main.bicep' = {
  name: 'justaccount'
  params: {
    location: location
    automationAccountName: 'justaccount-${uniqueString(resourceGroup().id, deployment().name)}'
    runbookName: ''
  }
}

module VmStartStop '../main.bicep' = {
  name: 'VmStart'
  params: {
    location: location
    automationAccountName: 'vmstart-${uniqueString(resourceGroup().id, deployment().name)}'
    runbookName: 'StartAzureVMs'
    runbookUri: 'https://raw.githubusercontent.com/azureautomation/start-azure-v2-vms/master/StartAzureV2Vm.graphrunbook'
    runbookType: 'GraphPowerShell'
    runbookDescription: 'This Graphical PowerShell runbook connects to Azure using an Automation Run As account and starts all V2 VMs in an Azure subscription or in a resource group or a single named V2 VM. You can attach a recurring schedule to this runbook to run it at a specific time.'
    runbookJobSchedule: [
      {
        schedule: 'Weekday - Midnight'
        parameters: {
          ResourceGroupName : 'myRG'
          VMName : 'myVM'
        }
      }
    ]
  }
}

module AksStartStop '../main.bicep' = {
  name: 'AksStartStop'
  params: {
    location: location
    automationAccountName: 'aksstartstop-${uniqueString(resourceGroup().id, deployment().name)}'
    runbookName: 'aks-cluster-changestate'
    runbookUri: 'https://raw.githubusercontent.com/Gordonby/aks-cluster-changestate/main/aks-cluster-changestate.ps1'
    runbookType: 'Script'
    runbookJobSchedule: [
      {
        Schedule: 'Weekday - 9am'
        parameters: {
          ResourceGroupName : 'myRG'
          AksClusterName : 'myVM'
          Operation: 'start'
        }
      }
      {
        Schedule: 'Weekday - 7pm'
        parameters: {
          ResourceGroupName : 'myRG'
          AksClusterName : 'myVM'
          Operation: 'stop'
        }
      }
    ]
  }
}
