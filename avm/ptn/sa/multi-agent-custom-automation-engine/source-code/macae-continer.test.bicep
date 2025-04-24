module macaeContainer './macae-continer.bicep' = {
  name: 'test-macae-continer.bicep'
  params: {
    prefix: 'macaesrc001'
    location: 'australiaeast'
    azureOpenAILocation: 'australiaeast'
  }
}
