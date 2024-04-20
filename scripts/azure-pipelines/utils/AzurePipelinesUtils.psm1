function Invoke-AzurePipelinesTask {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [ScriptBlock]$ScriptBlock
  )

  try {
    $ScriptBlock.Invoke();
  }
  catch {
    Write-Host "##vso[task.logissue type=error;]An error occurred: $_"
    Write-Output "##vso[task.complete result=Failed;]"
  }
  
  Exit $LASTEXITCODE
}

function Set-AzurePipelinesVariable {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$VariableName,

    [Parameter(mandatory = $true)]
    [AllowEmptyString()]
    [string]$VariableValue
  )
  
  Write-Host "##vso[task.setvariable variable=$VariableName;]$VariableValue" 
}

Export-ModuleMember -Function Invoke-AzurePipelinesTask, Set-AzurePipelinesVariable, Set-AzurePipelinesOutputVariable
