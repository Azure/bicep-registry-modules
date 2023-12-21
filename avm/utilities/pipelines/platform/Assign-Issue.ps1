function Get-AvmCsv {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateSet('Bicep-Resource', 'Bicep-Pattern', 'Terraform-Resource', 'Terraform-Pattern')]
    [string]$ModuleIndex
  )

  # Retrieve the CSV file
  if ($ModuleIndex -eq 'Bicep-Resource') {
    try {
      $unfilteredCSV = Invoke-WebRequest -Uri "https://aka.ms/avm/index/bicep/res/csv"
    }
    catch {
      Write-Error "Unable to retrieve CSV file - Check network connection."
    }
  }
  elseif ($ModuleIndex -eq 'Bicep-Pattern') {
    try {
      $unfilteredCSV = Invoke-WebRequest -Uri "https://aka.ms/avm/index/bicep/ptn/csv"
    }
    catch {
      Write-Error "Unable to retrieve CSV file - Check network connection."
    }
  }
  elseif ($ModuleIndex -eq 'Terraform-Resource') {
    try {
      $unfilteredCSV = Invoke-WebRequest -Uri "https://aka.ms/avm/index/tf/res/csv"
    }
    catch {
      Write-Error "Unable to retrieve CSV file - Check network connection."
    }
  }
  elseif ($ModuleIndex -eq 'Terraform-Pattern') {
    try {
      $unfilteredCSV = Invoke-WebRequest -Uri "https://aka.ms/avm/index/tf/ptn/csv"
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

function Set-Issue {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
  param (
    [Parameter(Mandatory = $true)]
    [string] $Repo,

    [Parameter(Mandatory = $true)]
    [string] $IssueUrl
  )

  $issue = gh issue view $IssueUrl.Replace('api.', '').Replace('repos/', '') --json 'author,title,url,body,comments' --repo $Repo | ConvertFrom-Json -Depth 100
  $moduleName = ($issue.body.Split("`n") -match "avm/(?:res|ptn)")[0].Trim().Replace(' ', '')
  $moduleIndex = $moduleName.StartsWith("avm/res") ? "Bicep-Resource" : "Bicep-Pattern"
  $module = Get-AvmCsv -ModuleIndex $moduleIndex | Where-Object ModuleName -eq $moduleName
  $reply = @"
@$($issue.author.login), thanks for submitting this issue for the ``$moduleName`` module!

A member of the @azure/$($module.ModuleOwnersGHTeam) or @azure/$($module.ModuleContributorsGHTeam) team will review it soon!
"@

  if ($PSCmdlet.ShouldProcess("Issue [$issue.title]", 'assign, add comments and labels')) {
    # add labels
    gh issue edit $issue.url --add-label "Needs: Attention :wave:" --repo $Repo
    gh issue edit $issue.url --add-label ($moduleIndex -eq "Bicep-Resource" ? "Class: Resource Module :package:" : "Class: Pattern Module :package:") --repo $Repo
    # write comment
    gh issue comment $issue.url --body $reply --repo $Repo
    # assign owner
    $assign = gh issue edit $issue.url --add-assignee $module.PrimaryModuleOwnerGHHandle --repo $Repo

    if ($null -eq $assign) {
      $reply = "This issue couldn't be assigend to $($module.PrimaryModuleOwnerGHHandle), because no such users exists."
      gh issue comment $issue.url --body $reply --repo $Repo
    }
  }

  Write-Verbose ('issue {0}{1} updated' -f $issue.title, $($WhatIfPreference ? ' would have been' : ''))
}