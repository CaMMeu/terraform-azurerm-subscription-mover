# TimerTrigger 

The `TimerTrigger` executes on a schedule. This function runs every 5 minutes.

## How it works

The Azure Function checks for every subscription within the source management group if the subscription's quota id matches the given quota id `MSDN_2014_09_01`. If that is the case, the subscription will be moved to the target management group. 
