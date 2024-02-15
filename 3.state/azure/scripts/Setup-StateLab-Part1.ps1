$firstName = Read-Host -Prompt 'What is your first name: '
$surname = Read-Host -Prompt 'What is your surname: '
$name = "$firstName-$surname".ToLower()

Write-Host "`nCreating resource group..."
$resp = $(az group create --location "uksouth" --name "rg-state-$name" | ConvertFrom-Json )
$rgName = $resp.name 
$rgId = $resp.id

Write-Host "Creating VNet..."
$resp = $(az network vnet create --name "vnet-state-$name" --resource-group $rgName --address-prefixes "10.1.0.0/16" | ConvertFrom-Json )
$vnetId = $resp.newVnet.id 
$vnetName = $resp.newVNet.Name
$vnetAddrSpace = $resp.newVnet.addressSpace.addressPrefixes

Write-Host "`nFinished creating resources!`n"
Write-Host "Resource group name is: $rgName" 
Write-Host "Resource group ID is: $rgId"
Write-Host "`nVNet name is: $vnetName" 
Write-Host "VNet ID is: $vnetId"
Write-Host "VNet Address Space is: [`"$vnetAddrSpace`"]"
Write-Host "`nYou'll need the values above when importing your resources!"
