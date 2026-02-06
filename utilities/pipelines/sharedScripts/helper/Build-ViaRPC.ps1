#region helper functions
<#
.SYNOPSIS
Send a message to a JSON-RPC server

.DESCRIPTION
Send a message to a JSON-RPC server.
NOTE: This fuction does NOT return the response. Use Read-BicepJsonRpcResponse to read the response.

.PARAMETER id
A unique identifier for the request. Each message should have a different id (e.g., an incrementing integer).

.PARAMETER method
The method name to invoke on the server (e.g., 'bicep/compile' / 'bicep/version')

.PARAMETER params
The payload to send to the server (e.g., @{ path = 'C:\path\to\file.bicep' })

.EXAMPLE
Send-BicepJsonRpc -id 1 -method 'bicep/compile' -params @{ path = 'C:\path\to\file.bicep' }

Compiles the specified Bicep file.

.EXAMPLE
Send-BicepJsonRpc -id 1 -method 'bicep/version' -params @{}

Gets the version of the Bicep CLI.
#>
function Send-BicepJsonRpc {
    param (
        [int]$id,
        [string]$method,
        [hashtable]$params
    )

    # Convert to JSON
    $json = @{
        jsonrpc = '2.0'
        id      = $id
        method  = $method
        params  = $params
    } | ConvertTo-Json -Compress

    # Calculate content length
    $length = $json.Length

    # Frame the request
    $message = "Content-Length: $length`r`n`r`n$json"

    # Send the request
    $proc.StandardInput.Write($message)
    $proc.StandardInput.Flush()
}

<#
.SYNOPSIS
Read the response from the JSON-PRC server

.DESCRIPTION
Read the response from the JSON-PRC server

.EXAMPLE
Read-BicepJsonRpcResponse

Returns the response from the JSON-PRC server.
#>
function Read-BicepJsonRpcResponse {
    # Read headers first
    $headers = @{}
    while ($true) {
        $line = $proc.StandardOutput.ReadLine()
        if ([string]::IsNullOrEmpty($line)) { break }
        if ($line -match 'Content-Length:\s*(\d+)') {
            $headers['Content-Length'] = [int]$matches[1]
        }
    }

    # Read content
    if ($headers.ContainsKey('Content-Length')) {
        $buffer = New-Object char[] $headers['Content-Length']
        $proc.StandardOutput.ReadBlock($buffer, 0, $buffer.Length) | Out-Null
        return ($buffer -join '')
    }

    return $null
}
#endregion

<#
.SYNOPSIS
Build a given template(s) via the Bicep JSON-RPC interface.

.DESCRIPTION
Build a given template(s) via the Bicep JSON-RPC interface. This is recommended if building many files at once, as it avoids the overhead of starting a new Bicep process for each file.

.PARAMETER BicepFilePath
The path(s) tof the Bicep file(s) to build.

.PARAMETER PassThru
Instead of compiling and writing the result to a JSON file in the same path as each Bicep file, return a hashtable with the Bicep file paths as keys and the compiled JSON content as values.

.EXAMPLE
Build-ViaRPC -BicepFilePath @('C:\path\to\file1.bicep', 'C:\path\to\file2.bicep')

Compiles the specified Bicep files and writes the resulting JSON files to the same directories (i.e., 'C:\path\to\file1.json' and 'C:\path\to\file2.json').

.EXAMPLE
Build-ViaRPC -BicepFilePath @('C:\path\to\file1.bicep', 'C:\path\to\file2.bicep') -PassThru

Compiles the specified Bicep files and returns a hashtable with the Bicep file paths as keys and the compiled JSON content as values, instead of writing to files.
#>
function Build-ViaRPC {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]] $BicepFilePath,

        [Parameter()]
        [switch] $PassThru
    )

    $StartTime = Get-Date

    # Start the JSON-RPC server in stdio mode
    $processInfo = New-Object 'System.Diagnostics.ProcessStartInfo'
    $processInfo.FileName = 'bicep' # Define Bicep executable path (assume it's in PATH)
    $processInfo.Arguments = 'jsonrpc --stdio'
    $processInfo.RedirectStandardInput = $true
    $processInfo.RedirectStandardOutput = $true
    $processInfo.UseShellExecute = $false
    $processInfo.CreateNoWindow = $true

    $proc = New-Object 'System.Diagnostics.Process'
    $proc.StartInfo = $processInfo
    $null = $proc.Start()

    $id = 1

    if ($PassThru) {
        $result = @{}
    }

    try {
        $completedBuildsCount = 0

        foreach ($filePath in $BicepFilePath) {
            Write-Verbose "Compiling [$filePath]"

            # Compile template
            Send-BicepJsonRpc -id $id -method 'bicep/compile' -params @{ path = $filePath }
            $response = (Read-BicepJsonRpcResponse | ConvertFrom-Json).result

            # Interpret response
            if ($response.success) {
                if ($PassThru) {
                    $result[$filePath] = $response.contents
                } else {
                    $filePathName = Split-Path -Path $filePath -LeafBase
                    $exportedTemplateFilePath = Join-Path (Split-Path -Path $filePath) "$filePathName.json"
                    $null = New-Item -Path $exportedTemplateFilePath -Value $response.contents -Force
                }
            } else {
                Write-Host 'Build failed:' -ForegroundColor 'Red'
                foreach ($diag in $response.diagnostics) {
                    Write-Host ('  [{0}] {1} (at {2}:{3},{4})' -f $diag.severity, $diag.message, $diag.range.start.line, $diag.range.start.character, $diag.range.end.character) -ForegroundColor 'Yellow'
                }
            }
            $id++

            # Update the progress display.
            $completedBuildsCount++
            [int] $percent = ($completedBuildsCount / $BicepFilePath.Count) * 100
            Write-Progress -Activity ("Processed [$completedBuildsCount/{0}] files" -f $BicepFilePath.Count) -Status "$percent% complete" -PercentComplete $percent

        }
    } catch {
        Write-Error "Failed to build template. Try running the command ``bicep build <templatePath> --stdout`` locally for troubleshooting. Make sure you have the latest Bicep CLI installed."
        throw $_
    } finally {
        # Close the process
        $proc.Kill()
    }

    $elapsedTime = (Get-Date) - $StartTime
    $totalTime = '{0:HH:mm:ss}' -f ([datetime]$elapsedTime.Ticks)
    Write-Verbose ("Execution took [$totalTime]")

    if ($PassThru) {
        return $result
    }
}
