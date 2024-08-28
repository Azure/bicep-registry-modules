$releaseData = Invoke-RestMethod -Uri "https://api.github.com/repos/actions/runner/releases/latest"

$releaseVersion = $releaseData.tag_name.Replace("v", "")

$filter = "actions-runner-linux-x64-$releaseVersion.tar.gz"

$releaseUrl = $releaseData.assets | Where-Object { $_.name -like $filter } | Select-Object 'browser_download_url'
$downloadUrl = $releaseUrl.browser_download_url

Write-Output "Got Download Url $downloadUrl. Downloading now..."
$fileName = "actions-runner-latest.tar.gz"
Invoke-WebRequest -Uri $downloadUrl -OutFile $fileName | Out-String | Write-Verbose

Write-Output "Got $fileName. Extracting now..."
tar xzf ./$fileName

Write-Output "Extracted $fileName. Cleaning up now..."
Remove-Item $fileName -Force ;
Write-Output "All done..."
