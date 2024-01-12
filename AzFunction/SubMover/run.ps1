<#
.SYNOPSIS
    Moves VSE Subscriptions from a source Management Group to another Management Group (target)
.DESCRIPTION
    This script moves in the source Management Group created VSE Subscriptions to the target Management Group every 5 minutes.
    This is done via checking for the Quota Id, which correlates with the Offer Id for VSE Subscriptions.
.EXAMPLE
#>

param($Timer)

#region Global variables
$azQuotaID = 'MSDN_2014-09-01'
$sourceManagementGroupName = $env:source_management_group_name
$targetManagementGroup =  $env:target_management_group_name
$ErrorActionPreference = "Stop"
#endregion

#region functions
function Get-QAzManagementGroupSubscription {
    param (
        [parameter(Mandatory)]
        [string] $GroupName
    )

    $apiPath = "/providers/Microsoft.Management/managementGroups/$GroupName/subscriptions?api-version=2021-04-01"
    $content = Invoke-QAzRestMethod -Method GET -Path $apiPath

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
    $content = Invoke-QAzRestMethod -Method PUT -Path $apiPath

    return $content
}

function Invoke-QAzRestMethod {
    param (
        [parameter(Mandatory)]
        [string] $Method,
        [parameter(Mandatory)]
        [string] $Path
    )

    $apiResponse = Invoke-AzRestMethod -Method $Method -Path $Path
    $content = ConvertFrom-Json $apiResponse.Content
    
    switch ($apiResponse.StatusCode) {
        200 { 
            return $content
        }
        Default {
            $message = "Failed to $Method $Path : $($result.StatusCode)"
            if ($content.error.message) {
                $message = $content.error.message
            }
            $exception = [Microsoft.Rest.Azure.CloudException]::new($message)
            $cloudError = [Microsoft.Rest.Azure.CloudError]::new()
            $cloudError.Code = $content.error.code
            $cloudError.Message = $content.error.message
            $exception.Body = $cloudError
            throw $exception
        }
    }    
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
