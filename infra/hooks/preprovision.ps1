# Prompt for resource group name if not already set
$rgName = $null
try {
    $rgName = azd env get-value AZURE_RESOURCE_GROUP_NAME 2>$null
    if ($LASTEXITCODE -ne 0) { $rgName = $null }
} catch {
    $rgName = $null
}

if (-not $rgName -or $rgName -match 'ERROR:') {
    Write-Host "Note: If the resource group already exists, the location will be picked from the resource group location."
    $rgName = Read-Host "Enter the Azure resource group name"
    if (-not $rgName) {
        Write-Error "Resource group name is required."
        exit 1
    }
    azd env set AZURE_RESOURCE_GROUP_NAME $rgName
}

Write-Host "Using resource group: $rgName"

# Check if the resource group already exists
$rgJson = az group show --name $rgName 2>$null
if ($LASTEXITCODE -eq 0 -and $rgJson) {
    $rg = $rgJson | ConvertFrom-Json
    $rgLocation = $rg.location
    Write-Host "Resource group '$rgName' already exists in location '$rgLocation'. Using that location."
    azd env set AZURE_LOCATION $rgLocation
} else {
    Write-Host "Resource group '$rgName' does not exist yet. It will be created during provisioning."
}
