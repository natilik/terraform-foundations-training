<!-- 
###########################################
# Lab Part 1
###########################################
-->

1. First we are going to create some resources outside of Terraform, so we can try using "terraform import" to onboard them. Run the script scripts/Setup-StateLab-Part1.ps1 to prepare for this lab.

2. Using the details obtained from the output of the script above, import the objects into state. There are two terraform addresses that you need to import to:
  * azurerm_resource_group.state_lab
  * azurerm_virtual_network.state_lab

3. Take a moment to review the terraform.tfstate file you have generated when importing – look at the resource you just imported.

4. Use the “terraform state list” and “terraform state show <resource>” commands to inspect the state resources.

5. In your main.tf file, write the necessary supporting configuration for the resources you just imported. If you're unsure what settings are mandatory, you can always check registry.terraform.io. The terraform state show <resource> command will also help you.

6. Once you think your code matches the import, deploy the new virtual machine by running “terraform apply”. There should be no changes to the resource group or virtual network as part of this apply.

7. Don’t destroy anything yet – there is a second part to the lab.

<!-- 
###########################################
# Lab Part 2
###########################################
-->

1. In your main.tf, change the Terraform name label assigned to the virtual machine (the label after "azurerm_linux_virtual_machine") so that it is something other than “state_lab” (it doesn't matter what you choose, just change it). What happens if you plan now?

2. Once you’ve changed the label in code, use the relevant sub-command of “terraform state” to change the address of the resource in the state file so it matches. You need to do this without deleting and recreating the resource.

3. After making the change above, run a “terraform plan” - you’ll receive an error. Read the error, and try to understand why it is being generated, then fix the problem. Once fixed, you should be able to run “terraform plan” and there will be no changes to make.

4. There is a resource with a name label of “state_lab_delete_me” – remove this from state without deleting the actual file the resource created. Ensure a plan/apply has no changes to make after you’re done. 

5. Don’t destroy anything yet – there is a third and final part to this lab.

<!-- 
###########################################
# Lab Part 3
###########################################
-->

1. Run the scripts/Setup-StateLab-Part3.ps1 script to setup ready for the lab.

2. Add a suitable “azurerm backend” block to your top-level “terraform” block. The docs can assist you with the settings needed for this - https://www.terraform.io/language/settings/backends/azurerm. 

3. Once the backend block is in place, migrate the state to the remote location and confirm the file appears in the storage account.

4. Delete your local state files – does a plan/apply still work?

5. Finally, run a Terraform destroy, then run scripts/Cleanup-StateLab.ps1 to delete any manually created resources.
