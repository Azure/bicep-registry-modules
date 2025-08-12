metadata name = 'avm/ptn/alz/empty/wait'
metadata description = '''Azure Landing Zones - Bicep - Empty - Wait Module

This module is used to create sequential empty/blank ARM deployments to introuce an artificial wait between deployments in the pattern module. When the `wait()` and `retry()` functions become available in GA in Bicep, this approach will be deprecated and we will migrate to using those functions instead.
'''

targetScope = 'managementGroup'
