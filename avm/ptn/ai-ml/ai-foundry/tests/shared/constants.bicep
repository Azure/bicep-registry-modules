@export()
@description('Enforced location for all tests.')
var enforcedLocation = 'australiaeast'

@export()
@description('Tags for resources used in all tests.')
var tags = {
  SecurityControl: 'Ignore' // ignore security policies imposed on testing subscriptions
}
