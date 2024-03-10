targetScope = 'tenant'

resource enrollment 'Microsoft.Billing/enrollmentAccounts@2018-03-01-preview' existing = {
  name: '330242'
}

resource billingAccount 'Microsoft.Billing/billingAccounts@2020-05-01' existing = {
  name: '7690848'
}

output billingScopeId string = '/providers/Microsoft.Billing/billingAccounts/${billingAccount.id}/enrollmentAccounts/${enrollment.id}'
