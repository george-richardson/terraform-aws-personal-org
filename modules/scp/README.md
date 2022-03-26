# SCP Module

Templates an SCP with useful defaults.

## Adding your own SCP statements

Service Control Policies are an extremely powerful tool, however they are limited to a maximum of 5 attached to any one AWS Organization resource. If you find yourself hitting this limit you can add your own statements to the SCPs generated for any of the modules using the `override_policy_documents` variable.

For example:

```terraform

```