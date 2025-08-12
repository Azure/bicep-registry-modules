@sys.description('Optional. Parameters for the policy assignment if needed.')
param parameters object = {
  test1: 'value1'
  test2: 'value2'
  test3: 'value3'
  obj1: {
    prop1: 'value1'
    prop2: 'value2'
  }
  array1: [
    'value1'
    'value2'
    'value3'
  ]
}

@sys.description('Optional. Parameter Overrides for the policy assignment if needed, useful when passing in parameters via a JSON or YAML file via the `loadJsonContent`, `loadYamlContent` or `loadTextContent` functions. Parameters specified here will override the parameters and their corresponding values provided in the `parameters` parameter of this module.')
param parameterOverrides object = {
  test3: 'overriddenValue3'
  obj1: {
    prop2: 'overriddenValue2'
  }
  array1: [
    'overriddenValue1'
  ]
}

var parametersMerged = union(parameters, parameterOverrides)

output parameters object = parameters
output parameterOverrides object = parameterOverrides
output parametersMerged object = parametersMerged
