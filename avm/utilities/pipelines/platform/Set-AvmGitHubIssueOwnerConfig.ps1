<#
.SYNOPSIS
Parses AVM module CSV file

.DESCRIPTION
Depending on the parameter, the correct CSV file will be parsed and returned a an object

.PARAMETER ModuleIndex
Type of CSV file, that should be parsed ('Bicep-Resource', 'Bicep-Pattern', 'Terraform-Resource', 'Terraform-Pattern')

.EXAMPLE
Next line will parse the AVM Bicep modules
Get-AvmCsvData -ModuleIndex 'Bicep-Resource'

#>
Function Get-AvmCsvData {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateSet('Bicep-Resource', 'Bicep-Pattern', 'Terraform-Resource', 'Terraform-Pattern')]
    [string] $ModuleIndex
  )

  # CSV file URLs
  $BicepResourceUrl = "https://aka.ms/avm/index/bicep/res/csv"
  $BicepPatternUrl = "https://aka.ms/avm/index/bicep/ptn/csv"
  $TerraformResourceUrl = "https://aka.ms/avm/index/tf/res/csv"
  $TerraformPatternUrl = "https://aka.ms/avm/index/tf/ptn/csv"

  # Retrieve the CSV file
  if ($ModuleIndex -eq 'Bicep-Resource') {
    try {
      $unfilteredCSV = Invoke-WebRequest -Uri $BicepResourceUrl
    }
    catch {
      Write-Error "Unable to retrieve CSV file - Check network connection."
    }
  }
  elseif ($ModuleIndex -eq 'Bicep-Pattern') {
    try {
      $unfilteredCSV = Invoke-WebRequest -Uri $BicepPatternUrl
    }
    catch {
      Write-Error "Unable to retrieve CSV file - Check network connection."
    }
  }
  elseif ($ModuleIndex -eq 'Terraform-Resource') {
    try {
      $unfilteredCSV = Invoke-WebRequest -Uri $TerraformResourceUrl
    }
    catch {
      Write-Error "Unable to retrieve CSV file - Check network connection."
    }
  }
  elseif ($ModuleIndex -eq 'Terraform-Pattern') {
    try {
      $unfilteredCSV = Invoke-WebRequest -Uri $TerraformPatternUrl
    }
    catch {
      Write-Error "Unable to retrieve CSV file - Check network connection."
    }
  }
  else {
    Write-Error "Invalid ModuleIndex value"
    exit 1
  }

  # Convert the CSV content to a PowerShell object
  $formattedBicepFullCsv = ConvertFrom-CSV $unfilteredCSV.Content
  # Filter the CSV data where the ModuleStatus is 'Module Available :green_circle:'
  $filterCsvAvailableBicepModule = $formattedBicepFullCsv | Where-Object { $_.ModuleStatus -eq 'Module Available :green_circle:' }

  # Loop through each item in the filtered data
  foreach ($item in $filterCsvAvailableBicepModule) {
    # Remove '@Azure/' from the ModuleOwnersGHTeam property
    $item.ModuleOwnersGHTeam = $item.ModuleOwnersGHTeam -replace '@Azure/', ''
    # Remove '@Azure/' from the ModuleContributorsGHTeam property
    $item.ModuleContributorsGHTeam = $item.ModuleContributorsGHTeam -replace '@Azure/', ''
  }

  # Return the filtered and modified data
  return $filterCsvAvailableBicepModule
}

<#
.SYNOPSIS
Assigns issues to module owners and adds comments and labels

.DESCRIPTION
For the given issue, the module owner (according to the AVM CSV file) will be notified in a comment and assigned to the issue

.PARAMETER Repo
Repository name according to GitHub (owner/name)

.PARAMETER IssueUrl
The full GitHub URL to the issue

.EXAMPLE
Set-AvmGitHubIssueOwnerConfig -Repo 'Azure/bicep-registry-modules' -IssueUrl 'https://github.com/Azure/bicep-registry-modules/issues/757'

.NOTES
Will be triggered by the workflow avm.platform.assign-issue.yml
#>
function Set-AvmGitHubIssueOwnerConfig {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $true)]
    [string] $Repo,

    [Parameter(Mandatory = $true)]
    [string] $IssueUrl
  )

  $issue = gh issue view $IssueUrl.Replace('api.', '').Replace('repos/', '') --json 'author,title,url,body,comments' --repo $Repo | ConvertFrom-Json -Depth 100
  $moduleName = ($issue.body.Split("`n") -match "avm/(?:res|ptn)")[0].Trim().Replace(' ', '')
  $moduleIndex = $moduleName.StartsWith("avm/res") ? "Bicep-Resource" : "Bicep-Pattern"
  $module = Get-AvmCsvData -ModuleIndex $moduleIndex | Where-Object ModuleName -eq $moduleName
  $reply = @"
@$($issue.author.login), thanks for submitting this issue for the ``$moduleName`` module!

A member of the @azure/$($module.ModuleOwnersGHTeam) or @azure/$($module.ModuleContributorsGHTeam) team will review it soon!
"@

  if ($PSCmdlet.ShouldProcess("attention label to issue [$issue.title]", 'Add')) {
    # add labels
    gh issue edit $issue.url --add-label "Needs: Attention :wave:" --repo $Repo
  }

  if ($PSCmdlet.ShouldProcess("class label to issue [$issue.title]", 'Add')) {
    gh issue edit $issue.url --add-label ($moduleIndex -eq "Bicep-Resource" ? "Class: Resource Module :package:" : "Class: Pattern Module :package:") --repo $Repo
  }

  if ($PSCmdlet.ShouldProcess("reply comment to issue [$issue.title]", 'Add')) {
    # write comment
    gh issue comment $issue.url --body $reply --repo $Repo
  }

  if ($PSCmdlet.ShouldProcess(("owner [{0}] to issue [$issue.title]" -f $module.PrimaryModuleOwnerGHHandle), 'Assign')) {
    # assign owner
    $assign = gh issue edit $issue.url --add-assignee $module.PrimaryModuleOwnerGHHandle --repo $Repo
  }

  if ([String]::IsNullOrEmpty($assign)) {
    $reply = "This issue couldn't be assigend to $($module.PrimaryModuleOwnerGHHandle), because no such users exists."
    if ($PSCmdlet.ShouldProcess("missing user comment to issue [$issue.title]", 'Add')) {
      gh issue comment $issue.url --body $reply --repo $Repo
    }
  }

  Write-Verbose ('issue {0}{1} updated' -f $issue.title, $($WhatIfPreference ? ' would have been' : ''))
}