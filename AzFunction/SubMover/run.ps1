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
$AzQuotaID = 'MSDN_2014-09-01'
$SourceManagementGroupName = $env:source_management_group_name
$TargetManagementGroup = $env:target_management_group_name
#endregion

Write-Host($SourceManagementGroupName, $TargetManagementGroup)

#region move subscriptions matching the Quota ID from source management group to target management group
$AzMgmtSubs = Get-AzManagementGroupSubscription -GroupName $SourceManagementGroupName
foreach ($subscription in $AzMgmtSubs) {
    Write-Host($subscription.DisplayName)
    $subscriptionID = $subscription.Id -replace '.*/'               # Retrieve subscription ID (everything behind last '/')
    $subscriptionObj = Get-AzSubscription -SubscriptionId $subscriptionID 
    $subscriptionPolicies = $subscriptionObj.SubscriptionPolicies
    if ($subscriptionPolicies.QuotaId -EQ $AzQuotaID) {
        New-AzManagementGroupSubscription -GroupId $TargetManagementGroup -SubscriptionId $subscriptionID
    }
}
#endregion
