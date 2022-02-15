@description('The name of someone to say hi to.')
param name string

@description('The hello message.')
output greeting string = 'Hello from Bicep registry - Hi ${name}!'
