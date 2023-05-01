This folder contains the source code of function apps that executes the secret rotation. If change is made to this folder, it should be repackaged as the `functionapp.zip` to replace the one in the module root folder and be pushed to the repository.

# file list
* function folder: each folder is named as the function to be created in the function app, and contains the powershell file as the function's source code.
* host.json: host file of Azure function app, shared by all functions
* profile.ps1: execute user defined commands when the function app is booted up, used for e.g. authentication.
* proxies.json: proxy file of Azure function app.
* requirements.psd1: Specify powershell modules and their versions used by the app.
