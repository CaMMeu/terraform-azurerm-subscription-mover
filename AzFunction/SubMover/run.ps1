<#
.SYNOPSIS
    Moves VSE Subscriptions from Management Group "New" to "Sandbox"
.DESCRIPTION
    This script moves in management group "New" created VSE Subscriptions to "Sandbox" every 5 minutes.
    This is done via checking for the Quota Id, which correlates with the Offer Id for VSE Subscriptions.
.EXAMPLE
#>

param($Timer)

#region Global variables
$azQuotaID = 'MSDN_2014-09-01'
$sourceManagementGroupName = $env:source_management_group_name
$targetManagementGroup = $env:target_management_group_name
$ErrorActionPreference = "Stop"
#endregion

#region functions
function Get-QAzManagementGroupSubscription {
    param (
        [parameter(Mandatory)]
        [string] $GroupName
    )

    $apiPath = "/providers/Microsoft.Management/managementGroups/$GroupId/subscriptions?api-version=2021-04-01"
    $apiResponse = Invoke-AzRestMethod -Method GET -Path $apiPath
    $content = ConvertFrom-Json $apiResponse.Content

    return $content.value
}

function New-QAzManagementGroupSubscription {
    param (
        [parameter(Mandatory)]
        [string] $GroupId,
        [parameter(Mandatory)]
        [string] $subscriptionId
    )

    $apiPath = "/providers/Microsoft.Management/managementGroups/$GroupId/subscriptions/$($subscriptionId)?api-version=2021-04-01"
    $apiResponse = Invoke-AzRestMethod -Method PUT -Path $apiPath

    return $apiResponse
}
#endregion 

#region move subscriptions matching the Quota ID from source management group to target management group
$mgmtSubs = Get-QAzManagementGroupSubscription -GroupName $sourceManagementGroupName
foreach ($subscription in $mgmtSubs) {
    try {
        $subscriptionID = $subscription.Id -replace '.*/'               # Retrieve subscription ID (everything behind last '/')
        $subscriptionObj = Get-AzSubscription -SubscriptionId $subscriptionID 
        $subscriptionPolicies = $subscriptionObj.SubscriptionPolicies
        if ($subscriptionPolicies.QuotaId -EQ $azQuotaID) {
            New-QAzManagementGroupSubscription -GroupId $targetManagementGroup -SubscriptionId $subscriptionID
        }
    }
    catch {
        Write-Error $_ -ErrorAction Continue
    }
}
#endregion
