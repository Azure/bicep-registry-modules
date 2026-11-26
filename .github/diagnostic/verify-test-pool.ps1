$ErrorActionPreference = 'Stop'
if ($env:GITHUB_EVENT_NAME -cne 'workflow_dispatch' -or
    $env:GITHUB_REPOSITORY -cne 'Azure/bicep-registry-modules' -or
    $env:REMOVE_DEPLOYMENT -cne 'false' -or $env:DEPLOYMENT_VALIDATION -cne 'true') {
    throw 'The diagnostic requires a manual E2E run with retention enabled.'
}
$allowed = @(
    '1c12b7fddeb24e808944b6b1be241945f1dbc0ad1ea1ff29bc963c502fbc3e62'
    '22dfd881f24dd64508b48ededc3c297d3bef671d16cca1bbcd1fa883491f8a77'
    '26c87800d012ca88aa456ebe30cb3fe62dd962a0e5ee2f7581ea3104bcc12008'
    '2a5c8d11fa32c88fb0e252d5061e389ccc23365e0e28a2f5abf22e6484631e75'
    '3a09fd0c229a22cbe94a6767e619b49e5a7465d1b43f64e34c61818858cb4800'
    '3b954cf76f8246647c5ba619068d1897b4b50753ae46335dca25ba048e109b9a'
    '43d941edd66c52a8769d2413c06cf3dc17ec356a5bab5728191317fe79dfc075'
    '47235f256da389d3c2274c9006b74fc05d07ac11eecf31576d81f8346e12d7d3'
    '5cebaf3458463a2f64f6110632ea258b1e90468189bd1fb74d6d8c0d262f037a'
    '5ec11af27fa44336332b50ab2557a0ae31db8ea6ef2f9cbb459ffa982fdd15db'
    '66e390d4610092ce2b09aa4f272df6e63171f18b40a943f513ce0e89aefe463c'
    '68f0d97cfe3d2e0f131a0053383e273d444fa2d5477fd2dd689ff5d5b62c56e8'
    '6aff09fafe26948e3aff666f73a79ba27c9500aa4a204463d4ee1e775a625ed6'
    '6cafdf6a1969f136c32534876e4af2fff1d97dbd58d1ef5a4d3506103c58a2f8'
    '7034559e856a023f421593427f269a15a57e518164fbc1f471c3de68b4aefb51'
    '75e258236014a4b0096a42ad6df0cea87014500962d627ee4716ec368a156c6e'
    '7947363e4126f00e2f5b5069a6609688759d93a3eb1a299c84cf410eb337e643'
    '83cb449e5c0a4710697bc62c41dee6ee9babfa9b2c61f78490106aeaf2bcef8d'
    '84e3e685c90e0facb499d0e45d5d5644b72eae550498ea8c46af3d26ca37786b'
    '8f367316f542f42285eddbf6b8ca04bea9a00d7b95772dd71ffad82097ca8eb8'
    'a6b541372651e022089a7eb5953e68a85fe0cbd51f4e88f205ef21c75696c5e3'
    'ae9d873ca2cd39605ca3aea10f4ea4c2976992d2cf06d87965d9f0baf9317088'
    'cf2acddebd7d79d969c7b2b82ce314ec64f5f3051c087b6aa400f6c8c26d34c8'
    'd68e8a2060e1da0a644be84169af68e8ef18d7879c87552efc2a3cf60bd45a58'
    'dfeeb5eba8362a590445fb0d0ce65282f0477485c8778cb1e056652c1f530f23'
    'e7119bed6f8bd229dd16a44bddbc5a4467779c9f1b1f4b7277085cc58ab8e199'
    'e8f7cb4083ca63d397ff4d14ae0ab841724a3b27a8ba03c0ad9770518c85e932'
    'fe07465018a6e5d497e4983dfd0075ffb15974ab39aaf0ceb608cd01caee9bdc'
)

if ([string]::IsNullOrWhiteSpace($env:TEST_SUBSCRIPTION_IDS)) {
    throw 'The test subscription pool is empty; refusing singleton fallback.'
}
$pool = ConvertFrom-Json -InputObject $env:TEST_SUBSCRIPTION_IDS -AsHashtable -NoEnumerate
if ($pool -isnot [array] -or $pool.Count -eq 0) {
    throw 'The test subscription pool must be a nonempty array.'
}
foreach ($entry in $pool) {
    $id = [guid]::Empty
    if ($entry -isnot [System.Collections.IDictionary] -or -not [guid]::TryParseExact([string]$entry.id, 'D', [ref]$id)) {
        throw 'The test subscription pool contains an invalid entry.'
    }
    $bytes = [Text.Encoding]::UTF8.GetBytes($id.ToString('D').ToLowerInvariant())
    $hash = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes)).ToLowerInvariant()
    if ($hash -cnotin $allowed) {
        throw 'The test subscription pool contains a subscription outside the observed test pool.'
    }
}
Write-Host "Verified $($pool.Count) subscriptions against the observed test pool."
