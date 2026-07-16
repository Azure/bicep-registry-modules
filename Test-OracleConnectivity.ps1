# Hardcoded connection details
$server = 'myoracledb.example.com'
$port = 1521
$service = 'ORCL'
$user = 'scott'
$pass = 'tiger'

$connStr = 'Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={0})(PORT={1}))(CONNECT_DATA=(SERVICE_NAME={2})));User Id={3};Password={4};' -f $server, $port, $service, $user, $pass

# Test TCP connectivity
Write-Host "Testing TCP connectivity to ${server}:${port}..." -ForegroundColor Cyan
$tcp = Test-NetConnection -ComputerName $server -Port $port -WarningAction SilentlyContinue
if (-not $tcp.TcpTestSucceeded) {
    Write-Host "TCP connection to ${server}:${port} failed." -ForegroundColor Red
    exit 1
}
Write-Host 'TCP connection successful.' -ForegroundColor Green

# Load Oracle driver
$dllPath = $null
if ($env:ORACLE_HOME -and (Test-Path $env:ORACLE_HOME)) {
    $dllPath = Get-ChildItem -Path $env:ORACLE_HOME -Filter 'Oracle.ManagedDataAccess.dll' -Recurse -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
}
if ($dllPath) {
    Add-Type -Path $dllPath
} else {
    try {
        [void][System.Reflection.Assembly]::LoadWithPartialName('Oracle.ManagedDataAccess')
    } catch {
        Write-Host 'Oracle.ManagedDataAccess.dll not found. Set ORACLE_HOME or install the NuGet package.' -ForegroundColor Red
        exit 1
    }
}

# Connect and test
Write-Host 'Connecting to Oracle...' -ForegroundColor Cyan
try {
    $conn = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($connStr)
    $conn.Open()

    Write-Host 'Connection successful!' -ForegroundColor Green
    Write-Host "  Server Version : $($conn.ServerVersion)"
    Write-Host "  Database Name  : $($conn.DatabaseName)"

    $cmd = $conn.CreateCommand()
    $cmd.CommandText = 'SELECT SYSDATE FROM DUAL'
    $result = $cmd.ExecuteScalar()
    Write-Host "  SYSDATE        : $result"

    $cmd.Dispose()
    $conn.Close()
    $conn.Dispose()

    Write-Host "`nOracle connectivity test PASSED." -ForegroundColor Green
} catch {
    Write-Host "Oracle connection failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
