# This script removes a feature from content databases
# Use after CA reports missing features


[CmdletBinding()]

Param(
  [Parameter(Mandatory=$true)]
  $feature
)


Function main()
{
  Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue

  $webapps = @("https://online-dev.smiths.com", "https://portal-dev.smiths.com")

  Foreach($webapp in $webapps)
  {
    $cdbs = Get-SPContentDatabase -WebApplication $webapp

    Foreach($cdb in $cdbs)
    {
      Foreach($site in $cdb.Sites)
      {
        $sitefeature = $site.Features[$feature]
        If($sitefeature -eq $null)
        {
          $sitefeature = "Not found"
        }

        New-Object PSObject -Property @{
          Webapp = $webapp
          ContentDB = $cdb
          Site = $site
          Feature = $sitefeature
        }
      }
    }
  }

}

main

<#
function Remove-SPFeatureFromContentDB($ContentDb, $FeatureId, [switch]$ReportOnly)
{
    $db = Get-SPDatabase | where { $_.Name -eq $ContentDb }

    $db.Sites | ForEach-Object {

        Remove-SPFeature -obj $_ -objName "site collection" -featId $FeatureId -report $report

        $_ | Get-SPWeb -Limit all | ForEach-Object {

            Remove-SPFeature -obj $_ -objName "site" -featId $FeatureId -report $report
        }
    }
}

function Remove-SPFeature($obj, $objName, $featId, [bool]$report)
{
    $feature = $obj.Features[$featId]

    if ($feature -ne $null) {
        if ($report) {
            write-host "Feature found in" $objName ":" $obj.Url -foregroundcolor Red
        }
        else
        {
            try {
                $obj.Features.Remove($feature.DefinitionId, $true)
                write-host "Feature successfully removed from" $objName ":" $obj.Url -foregroundcolor Red
            }
            catch {
                write-host "There has been an error trying to remove the feature:" $_
            }
        }
    }
    else {
        #write-host "Feature ID specified does not exist in" $objName ":" $obj.Url
    }
}
#>
