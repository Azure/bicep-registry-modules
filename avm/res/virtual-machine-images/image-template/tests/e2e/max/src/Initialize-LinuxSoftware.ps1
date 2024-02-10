#region Functions
function LogInfo($message) {
    Log 'Info' $message
}
function LogError($message) {
    Log 'Error' $message
}
function LogWarning($message) {
    Log 'Warning' $message
}

function Log {

    <#
    .SYNOPSIS
    Creates a log file and stores logs based on categories with tab seperation

    .PARAMETER category
    Category to put into the trace

    .PARAMETER message
    Message to be loged

    .EXAMPLE
    Log 'Info' 'Message'

    #>

    Param (
        [Parameter(Mandatory = $false)]
        [string] $category = 'Info',

        [Parameter(Mandatory = $true)]
        [string] $message
    )

    $date = Get-Date
    $content = "[$date]`t$category`t`t$message`n"
    Write-Verbose $Content -Verbose

    $FilePath = Join-Path ([System.IO.Path]::GetTempPath()) 'log.log'
    if (-not (Test-Path $FilePath)) {
        Write-Verbose "Log file not found, create new in path: [$FilePath]" -Verbose
        $null = New-Item -ItemType 'File' -Path $FilePath -Force
    }
    Add-Content -Path $FilePath -Value $content -ErrorAction 'Stop'
}
#endregion

$StartTime = Get-Date
$progressPreference = 'SilentlyContinue'
LogInfo('#############################################')
LogInfo('#   Entering Initialize-LinuxSoftware.ps1   #')
LogInfo('#############################################')

###########################
##   Install Azure CLI   ##
###########################
LogInfo('Install azure cli start')
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
LogInfo('Install azure cli end')

##########################
##   Install Az Bicep    #
##########################
LogInfo('Install az bicep exention start')
az bicep install
LogInfo('Install az bicep exention end')

###########################
##   Install BICEP CLI   ##
###########################
LogInfo('Install BICEP start')

# Fetch the latest Bicep CLI binary
curl -Lo bicep 'https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64'
# Mark it as executable
chmod +x ./bicep
# Add bicep to your PATH (requires admin)
sudo mv ./bicep /usr/local/bin/bicep

LogInfo('Install BICEP end')


$elapsedTime = (Get-Date) - $StartTime
$totalTime = '{0:HH:mm:ss}' -f ([datetime]$elapsedTime.Ticks)
LogInfo("Execution took [$totalTime]")
LogInfo('############################################')
LogInfo('#   Exiting Initialize-LinuxSoftware.ps1   #')
LogInfo('############################################')

return 0
#endregion
