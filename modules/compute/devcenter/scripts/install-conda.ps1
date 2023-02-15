$Error.Clear()

environment_vars = [
           "install_log_file=C:\\Users\\Public\\Desktop\\INSTALLED_SOFTWARE.txt",
           "dlink_conda=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe",
           "conda_install_destination=C:\\miniconda3"
]

function DownloadFile {
    param ([string] $url, [string] $localFile, [bool] $suppressOutput=$false)

    $maxRetries = 3
    $retryCount = 0

    if (-not $supressOutput) { Write-Output "Downloading $url to $localFile" }

    while (-not(Test-Path $localFile) -and $retryCount -le $maxRetries -and $Error.Count -eq 0) {
        Try {
            $client = new-object System.Net.WebClient
            $client.DownloadFile($url, $localFile)
            if (-not $supressOutput) { Write-Output "Download to $localFile completed..." }
        }
        Catch {
            $retrycount++
            if ($retryCount -le $maxRetries) {
                $Error.Clear()
                if (-not $supressOutput) { Write-Output "Retrying download of $url, retry number $retryCount" }
            }
        }
    }
}

$condaLocation = $env:Public + '\conda'
New-Item -ItemType 'directory' -Path $condaLocation
$condaSetup = $condaLocation + '\condasetup.exe'

DownloadFile -url $env:dlink_conda -localFile $condaSetup
Write-Output 'TASK COMPLETED: Conda downloaded...'

Write-Output 'TASK STARTED: Conda installing...'
Start-Process $condaSetup -ArgumentList "/InstallationType=AllUsers", "/AddToPath=1", "/S", "/D='$env:conda_install_destination'" -NoNewWindow -Wait
Add-Content "$env:install_log_file" "- Miniconda"
Write-Output 'TASK COMPLETED: Conda installed...'

if ($Error.Count -gt 0) { Write-Output 'ERRORS:'; for ( $i=$Error.Count-1; $i -ge 0; $i--) { $err=$Error[$i]; Write-Output "Line $($err.InvocationInfo.ScriptLineNumber): $($err.InvocationInfo.Line.Trim())    Error: $($err.Exception.Message)" }; throw 'Script errors' }
