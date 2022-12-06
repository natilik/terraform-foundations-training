# Lab - Local Workspaces

1. Navigate to the “4.workspaces directory”. Some very simple code has been provisioned to allow you to see what happens when using workspaces, and how your code needs to account for them somehow.
Don’t worry about some of the more advanced syntax – we cover that in the coming days.
Main focus is on the use of “terraform.workspace” in conjunction with the workspaces we create.

2. Issue the “terraform workspace list” command to validate you just have the one, default, workspace.

3. Run an init/plan/apply from the default workspace and keep an eye on your local state file and the bucket/storage account name which was selected.

4. Create two new workspaces named env1 and env2 – do you notice a new directory?

5. Select (“terraform workspace select <name>”) each of these workspaces in turn and run another plan/apply – again, keep an eye on your state files, the selected bucket name and the name tags.

6. Select your default workspace again and try to delete workspace “env2” – what happens?

7. Select each environment again (including default), this time destroying the resources.

8. Delete the non-default workspaces once you’re done – they will now be deleted without issue.

