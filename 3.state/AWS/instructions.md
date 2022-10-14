# Lab Part 1 - Importing

1. Using the repo we cloned earlier, navigate to the “3.state” directory and select the AWS or Azure sub-directory (based on your lab preference).

2. Using the relevant CLI, create a resource outside of Terraform and note the ID that is returned.
    * AWS – See “aws_cli_commands.txt”.
    * Azure – See “az_cli_commands.txt”.

3. Open the main.tf file and search for the string # IMPORT_ME. Using the ID obtained in step 2, import the object into state.

4. Take a moment to review the terraform.tfstate file you have saved – look at the resource you just imported.

5. Use the “terraform state list” and “terraform state show <resource>” commands to inspect the state resources.

6. Write the necessary supporting configuration for the resource you just imported, then deploy the new virtual machine by running “terraform apply”. Don’t destroy anything yet – there is a second part to the lab.


# Lab Part 2 - State Address Changes

1. In your main.tf, change the name label assigned to the instance/virtual machine so that it is something other than “state_lab”. 

2. Once you’ve changed the label in main.tf, use the relevant sub-command of “terraform state” to change the address of the resource in the state file, without needing to delete and recreate it.

3. After making the change above, run a “terraform plan”. You’ll receive an error. Read the error, understand why it is being generated and fix the problem. Once fixed, you should be able to run “terraform plan” and there will be no changes to make.

4. There is a resource with the name “state_lab_delete_me” – remove this from Terraform’s management without deleting the actual file – ensure a plan/apply has no changes to make after you’re done. Don’t destroy anything yet – there is a third and final part to this lab.

# Lab Part 3 - State Migration
1. Create a Storage Account (Azure) or S3 bucket (AWS) using the commands in the files shown below. Note: in production, it would be important to ensure you secure these per best-practices:
    * AWS – See “aws_cli_commands.txt”.
    * Azure – See “az_cli_commands.txt”.

2. Add a suitable “backend” block to your top-level “terraform” block.
    * S3 – https://www.terraform.io/language/settings/backends/s3
    * Azurerm – https://www.terraform.io/language/settings/backends/azurerm 

3. Migrate the state to the remote location and confirm the file appears in the storage account/bucket.

4. Delete your local state files – does a plan/apply still work?

5. Destroy your infrastructure (“terraform destroy”), then delete the storage account/S3 bucket:
    * AWS – See “aws_cli_commands.txt”.
    * Azure – See “az_cli_commands.txt”.



