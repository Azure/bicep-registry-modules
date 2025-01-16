<#
.SYNOPSIS
Split a given array evenly into chunks of n-items

.DESCRIPTION
Split a given array evenly into chunks of n-item

.PARAMETER InputArray
Mandatory. The array to split

.PARAMETER SplitSize
Mandatory. The chunk size to split into.

.EXAMPLE
Split-Array -InputArray @('1','2,'3','4','5') -SplitSize 3

Split the given array @('1','2,'3','4','5') into chunks of size '3'. Will return the multi-demensional array @(@('1','2,'3'),@('4','5'))
#>
function Split-Array {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object[]] $InputArray,

        [Parameter(Mandatory = $true)]
        [int] $SplitSize
    )
    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }
    process {

        if ($splitSize -ge $InputArray.Count) {
            return $InputArray
        } else {
            $res = @()
            for ($Index = 0; $Index -lt $InputArray.Count; $Index += $SplitSize) {
                $res += , ( $InputArray[$index..($index + $splitSize - 1)] )
            }
            return $res
        }
    }
    end {
        Write-Debug ('{0} existed' -f $MyInvocation.MyCommand)
    }
}
