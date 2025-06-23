# idempotent: TBD
# TODO: no try, try outside

param(
    [Parameter(Mandatory = $true)]
    [string]$IP, # or name
    [Parameter(Mandatory = $false)]
    [int]$Port = 5985,
    [Parameter(Mandatory = $false)]
    [string]$Authentication = 'Default',
    [Parameter(Mandatory = $true)]
    [string]$DomainFQDN,
    [Parameter(Mandatory = $true)]
    [string]$AdministratorAccount,
    [Parameter(Mandatory = $true)]
    [string]$AdministratorPassword,
    [Parameter(Mandatory = $true)]
    [string]$ADOUPath,
    [Parameter(Mandatory = $true)]
    [string]$DeploymentUserAccount,
    [Parameter(Mandatory = $true)]
    [string]$DeploymentUserPassword
)

$script:ErrorActionPreference = 'Stop'

try {
    $username = "$($DomainFQDN.Split('.')[0])\$AdministratorAccount"
    $securePassword = ConvertTo-SecureString $AdministratorPassword -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePassword
    $session = New-PSSession -ComputerName $IP -Port $Port -Authentication $Authentication -Credential $credential

    Invoke-Command -Session $session -ScriptBlock {
        Add-KdsRootKey -EffectiveTime ((Get-Date).addhours(-10)) -Verbose # TODO: is this idempotent?

        $deploymentSecurePassword = ConvertTo-SecureString $Using:DeploymentUserPassword -AsPlainText -Force
        $lcmCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $Using:DeploymentUserAccount, $deploymentSecurePassword
        New-HciAdObjectsPreCreation -AzureStackLCMUserCredential $lcmCredential -AsHciOUName $Using:ADOUPath -Verbose
        # automatically skipped if it exists
    }
} catch {
    Write-Error $_
} finally {
    if ($session) {
        Remove-PSSession -Session $session
    }
}
