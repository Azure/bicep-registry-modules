@description('An array containing names.')
param names array = [
  'Michael'
  'Dwight'
  'Jim'
  'Pam'
]

@description('An output demonstrating iterating array items with an item variable.')
output namesByVariable array = [for name in names: {
  name: name
}]

@description('An output demonstrating iterating array items with an index.')
output out3 array = [for (name, i) in names: {
  name: names[i]
}]
