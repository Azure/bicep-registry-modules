// Conflict fixed in 0.18: metadata name = 'Hello World'
metadata description = 'A \u{0022}שָׁלוֹם עוֹלָם\u{0022} sample Bicep registry module'
metadata owner = 'bicep-admins'

@sys.description('The name of someone to say hi to.')
param name string

@sys.description('The hello message.')
output greeting string = 'Hello from Bicep registry - Hi ${name}!'
