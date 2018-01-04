# TriggerManagement
>For triggers management in force.com/salesforce.

#### Version
v1.0.0

#### Resolve
Resovle the triggers execute order.

#### How to use
- You have to install or copy the TriggerManagement.cls to your org;
- You can split the function to the different handlers(apex class) that implements the TriggerManagement.Handler interface;
- Just only stay one trigger in per sObject and in the trigger you can just bind the handlers to execute that you expect execute order.

