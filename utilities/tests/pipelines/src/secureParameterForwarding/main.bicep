// These intentionally plain inputs are negative controls, not production interfaces.
param ordinary string
param entries entryType[]?
param settings settingsType?

type entryType = {
  name: string
  payload: string?
}

type settingsType = {
  nested: {
    arbitrary: string?
  }?
}

@secure()
type protectedType = {
  nested: {
    arbitrary: string
  }
}

param protectedSettings protectedType

@discriminator('kind')
type choiceType = safeChoiceType | plainChoiceType

type safeChoiceType = {
  kind: 'safe'
  @secure()
  arbitrary: string
}

type plainChoiceType = {
  kind: 'plain'
  arbitrary: string
}

param choice choiceType

module scalar 'child.bicep' = {
  name: 'scalar'
  params: {
    arbitrary: ordinary
  }
}

module items 'child.bicep' = [for entry in entries ?? []: {
  name: entry.name
  params: {
    arbitrary: entry.?payload
  }
}]

module nested 'child.bicep' = {
  name: 'nested'
  params: {
    arbitrary: settings.?nested.?arbitrary
  }
}

module ancestor 'child.bicep' = {
  name: 'ancestor'
  params: {
    arbitrary: protectedSettings.nested.arbitrary
  }
}

module discriminated 'child.bicep' = {
  name: 'discriminated'
  params: {
    arbitrary: choice.arbitrary
  }
}

module constant 'child.bicep' = {
  name: 'constant'
  params: {
    arbitrary: 'not-a-credential'
  }
}

module optional 'child.bicep' = {
  name: 'optional'
  params: {
    arbitrary: null
  }
}

module transformed 'child.bicep' = {
  name: 'transformed'
  params: {
    arbitrary: toLower(ordinary)
  }
}
