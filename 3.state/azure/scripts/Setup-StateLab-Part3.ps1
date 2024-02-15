$firstName = Read-Host -Prompt 'What is your first name: '
$surname = Read-Host -Prompt 'What is your surname: '
$name = "$firstName$surname".ToLower()

Write-Host "`nCreating resource group..."
$resp = $(az group create --location "uksouth" --name "rg-state-storage-$name" | ConvertFrom-Json )
$stateRgName = $resp.name
$stateRgId = $resp.id
$random = $(Get-Random -Maximum 99999)

Write-Host "Creating storage account..."
$resp = $(az storage account create --name "$name$random" --resource-group $stateRgName | ConvertFrom-Json )
$storageName = $resp.name
Write-Host "Creating container in storage account..."
az storage container create --name tfstate --account-name $storageName --only-show-errors | Out-Null

Write-Host "`nFinished creating resources!`n"
Write-Host "Resource group name is: $stateRgName" 
Write-Host "`nStorage Account name is: $storageName" 
Write-Host "Storage Account Container name is: tfstate"
Write-Host "Key value can be anything, but please use: terraform.tfstate"
Write-Host "`nYou'll need the values above when adding your backend block!"
Write-Host "https://developer.hashicorp.com/terraform/language/settings/backends/azurerm"
