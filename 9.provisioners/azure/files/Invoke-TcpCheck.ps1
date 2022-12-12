[CmdletBinding()]
param (
    [Parameter(mandatory = $true)]
    [String]$PublicIP,

    [Parameter(mandatory = $true)]
    [String]$FileName    
)

$response = Test-NetConnection -Port 22 -ComputerName $PublicIP
$timeStamp = (Get-Date).ToString("yyyy:MM:dd HH:mm:ss")
$content = "$timestamp - Successfully connected to $PublicIP on port 22."
Add-Content $FileName -Value $content