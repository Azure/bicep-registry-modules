@description('The name to greet.')
param name string

@description('The greeting message')
output greeting string = 'Hello, ${name}!'
