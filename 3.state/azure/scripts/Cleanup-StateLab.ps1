$firstName = Read-Host -Prompt 'What is your first name'
$surname = Read-Host -Prompt 'What is your surname'
$name = "$firstName$surname".ToLower()

Write-Host "`nDeleting resource group `"rg-state-storage-$name`"..."
$resp = $(az group delete --name "rg-state-storage-$name" --yes| ConvertFrom-Json )
Write-Host "Deletion complete!"
