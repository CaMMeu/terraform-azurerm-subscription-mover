<#
.SYNOPSIS
    Moves VSE Subscriptions from Management Group "New" to "Sandbox"
.DESCRIPTION
    This script moves in management group "New" created VSE Subscriptions to "Sandbox" every 5 minutes.
    This is done via checking for the Quota Id, which correlates with the Offer Id for VSE Subscriptions.
.EXAMPLE
#>

param($Timer)

Write-Host("hello, is this coming through?")

#region Global variables
$AzQuotaID = 'MSDN_2014-09-01'
$ManagementGroupName = 'CHHOL-New'
$NewManagementGroup = 'CHHOL-Sandbox'
#endregion

#region get subscriptions from management Group "New"
$AzMgmtSubs = Get-AzManagementGroupSubscription -GroupName $ManagementGroupName
foreach ( $subscription in $AzMgmtSubs ) {
    Write-Host($subscription.DisplayName)
    $subscriptionID = $subscription.Id -replace '.*/'       # Retrieve subsription ID (everything behind last '/')
    if ($subscriptionID -eq 'aff5a812-0595-4545-8b0e-527b199b4928') {
        Write-Host($subscriptionID)
        $subscriptionObj = Get-AzSubscription -SubscriptionId $subscriptionID 
        $subscriptionPolicies = $subscriptionObj.SubscriptionPolicies
        if ($subscriptionPolicies.QuotaId -EQ $AzQuotaID) {
            New-AzManagementGroupSubscription -GroupId $NewManagementGroup -SubscriptionId $subscriptionID
        }
    }
}
#endregion
