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
$azQuotaID = 'MS-AZR-0029P' # updated from MSDN_2014-09-01
$sourceManagementGroupName = $env:source_management_group_name
$targetManagementGroup = $env:target_management_group_name
#endregion


#region move subscriptions matching the Quota ID from source management group to target management group
$mgmtSubs = Get-AzManagementGroupSubscription -GroupName $sourceManagementGroupName
foreach ($subscription in $mgmtSubs) {
    try {
        $subscriptionID = $subscription.Id -replace '.*/'               # Retrieve subscription ID (everything behind last '/')
        $subscriptionObj = Get-AzSubscription -SubscriptionId $subscriptionID 
        $subscriptionPolicies = $subscriptionObj.SubscriptionPolicies
        if ($subscriptionPolicies.QuotaId -EQ $azQuotaID) {
            New-AzManagementGroupSubscription -GroupId $targetManagementGroup -SubscriptionId $subscriptionID
        }
    }
    catch {
        Write-Error $_ -ErrorAction Continue
    }
    
}
#endregion
