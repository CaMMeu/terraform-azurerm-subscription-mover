<#
.SYNOPSIS
    Moves VSE Subscriptions from Management Group "New" to "Sandbox"
.DESCRIPTION
    This script moves in management group "New" created VSE Subscriptions to "Sandbox" every 5 minutes.
    This is done via checking for the Quota Id, which correlates with the Offer Id for VSE Subscriptions.
.EXAMPLE
#>

# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
