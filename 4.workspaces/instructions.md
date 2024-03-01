# Lab - Local Workspaces

1. Navigate to the “4.workspaces directory” and select either the Azure or AWS sub-directory. Be sure to change location in your terminal using the “cd” command.

2. Some code has been provisioned to allow you to see what happens when using workspaces, and how your code needs to account for them somehow.

3. Issue the “terraform workspace list” command to validate you just have the one workspace called “default”.

4. Run an init/plan/apply from the default workspace and keep an eye the bucket/storage account name which was generated.

5. Create two new workspaces named env1 and env2 – do you notice a new directory?

6. Use “terraform workspace select <name>” to switch into each of the workspaces in turn and run another plan/apply. Have a look in the new directory at what gets created. Also keep an eye on the generated storage account/bucket names.

7. Select your default workspace again and try to delete workspace “env2” – what happens?

8. Select each environment again (including default), this time destroying the resources.

9. You should now be able to delete the non-default workspaces – go ahead and do so.