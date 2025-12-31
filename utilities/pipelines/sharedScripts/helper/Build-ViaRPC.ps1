#region helper functions
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
    $message = "Content-Length: $length`r`n`r`n$json" #`r`n`r`n"

    # Send the request
    $proc.StandardInput.Write($message)
    $proc.StandardInput.Flush()
}

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

function Build-ViaRPC {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]] $BicepFiles,

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

        foreach ($file in $BicepFiles) {
            Write-Verbose ('Compiling [{0}]' -f ($file -replace [regex]::Escape('C:\dev\ip\bicep-registry-modules\Upstream-Azure\')))

            # Compile template
            Send-BicepJsonRpc -id $id -method 'bicep/compile' -params @{ path = $file }
            $response = (Read-BicepJsonRpcResponse | ConvertFrom-Json).result

            # Interpret response
            if ($response.success) {
                if ($PassThru) {
                    $result[$file] = $response.contents
                } else {
                    $fileName = Split-Path -Path $file -LeafBase
                    $exportedTemplateFilePath = Join-Path (Split-Path -Path $file) "$fileName.json"
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
            [int] $percent = ($completedBuildsCount / $BicepFiles.Count) * 100
            Write-Progress -Activity ("Processed [$completedBuildsCount/{0}] files" -f $BicepFiles.Count) -Status "$percent% complete" -PercentComplete $percent

        }
    } catch {
        throw $_
    } finally {
        # Close the process
        $proc.Kill()
    }

    $elapsedTime = (Get-Date) - $StartTime
    $totalTime = '{0:HH:mm:ss}' -f ([datetime]$elapsedTime.Ticks)
    Write-Host ("Execution took [$totalTime]")

    if ($PassThru) {
        return $result
    }
}
