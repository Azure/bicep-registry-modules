param(
    [Parameter(Mandatory = $true)]
    [int]$Minutes
)

for ($i = 0; $i -lt $Minutes; $i++) {
    Start-Sleep -Seconds 60
}
