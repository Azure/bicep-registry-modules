metadata description = 'A sample Bicep registry module demonstrating array iterations.'

@sys.description('An array containing names.')
param names array = [
  'Michael'
  'Dwight'
  'Jim'
  'Pam'
]

@sys.description('An output demonstrating iterating array items with an item variable.')
output namesByVariable array = [for name in names: {
  name: name
}]

@sys.description('An output demonstrating iterating array items with an index.')
output out3 array = [for (name, i) in names: {
  name: names[i]
}]
