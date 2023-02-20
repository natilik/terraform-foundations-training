<!-- 
###########################################
# IMPORTANT
###########################################
# Please run the following commands in PowerShell. 
# If you close your shell and re-open it part way through,
# you'll lose the variables we create. Please ensure
# you use the same terminal all the way through this lab.
-->

<!-- 
###########################################
# Lab Part 1
###########################################
-->

1. First we are going to create some resources outside of Terraform, so we can try using "terraform import" to onboard them. Use "find and replace" to replace <name> in this document with your firstname-surname. CTRL-H is the keyboard shortcut in VSCode to bring up find and replace. Replace all instances.

2. Paste the commands shown below (except the backticks if shown) into PowerShell. Note the Resource Group ID and VNet ID - you'll need them shortly.
```
$name = "<name>"
$rgName = $(az group create --location "uksouth" --name "rg-state-$name" | jq -r ".name")
$rgId = $(az group show --name $rgName | jq -r ".id")
$vnetId = $(az network vnet create --name "vnet-state-$name" --resource-group $rgName --address-prefixes "10.1.0.0/16" | jq -r ".newVNet.id")
echo "`n`n`nResource Group ID is $rgId `nVNet ID is $vnetId`n`n"
```

3. Open the main.tf file and search for the string "# IMPORT_ME". Using the IDs obtained in step 2, import the objects into state.

4. Take a moment to review the terraform.tfstate file you have generated when importing – look at the resource you just imported.

5. Use the “terraform state list” and “terraform state show <resource>” commands to inspect the state resources.

6. In your main.tf file, write the necessary supporting configuration for the resources you just imported, then deploy the new virtual machine by running “terraform apply”. Don’t destroy anything yet – there is a second part to the lab.

<!-- 
###########################################
# Lab Part 2
###########################################
-->

1. In your main.tf, change the Terraform name label assigned to the virtual machine so that it is something other than “state_lab” (it doesn't matter what you choose). 

2. Once you’ve changed the label in main.tf, use the relevant sub-command of “terraform state” to change the address of the resource in the state file as well. You need to do this without needing to delete and recreate the resource.

3. After making the change above, run a “terraform plan” - you’ll receive an error. Read the error, understand why it is being generated and fix the problem. Once fixed, you should be able to run “terraform plan” and there will be no changes to make.

4. There is a resource with a name label of “state_lab_delete_me” – remove this from Terraform’s management without deleting the actual file – ensure a plan/apply has no changes to make after you’re done. Don’t destroy anything yet – there is a third and final part to this lab.

<!-- 
###########################################
# Lab Part 3
###########################################
-->

1. Paste the commands shown below (except the backticks if shown) into PowerShell. Note the storage account name and resource group name - you'll need them shortly. We are not configuring the storage account per secure best-practices, something that would be important in the real-world.

```
$stateRgName = $(az group create --location "uksouth" --name "rg-state-storage-$name" | jq -r ".name")
$stateRgId = $(az group show --name $stateRgName | jq -r ".id")
$random = $(Get-Random -Maximum 99999)
$stateStgAcctName = $(az storage account create --name "$name$random" --resource-group $stateRgName | jq -r ".name")
az storage container create --name tfstate --account-name $stateStgAcctName 
echo "`n`n`nStorage Account Name is $stateStgAcctName `nContainer name is tfstate`n`n"
```

2. Add a suitable “azurerm backend” block to your top-level “terraform” block. The docs can assist you with the settings needed for this - https://www.terraform.io/language/settings/backends/azurerm. 

3. Once the backend block is in place, migrate the state to the remote location and confirm the file appears in the storage account.

4. Delete your local state files – does a plan/apply still work?

5. Run a Terraform destroy, then manually delete the storage account using the commands shown below. Paste the commands shown below (except the backticks if shown) into PowerShell:

```
az storage account delete --name $stateStgAcctName --yes 
az group delete --name $stateRgName --yes
```
