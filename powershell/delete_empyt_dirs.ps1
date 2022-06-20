# Set to true to test the script
$testMode = $true

# Remove hidden files, like thumbs.db
$removeHiddenFiles = $false

# Get hidden files or not. Depending on removeHiddenFiles setting
$getHiddelFiles = !$removeHiddenFiles

# function to delete emty directories
Function Delete-EmptyFolder($path)
{
    # Go through each subfolder, 
    Foreach ($subFolder in Get-ChildItem -Force -Literal $path -Directory) 
    {
        # Call the function recursively
        Delete-EmptyFolder -path $subFolder.FullName
    }

    # Get all child items
    $subItems = Get-ChildItem -Force:$getHiddelFiles -LiteralPath $path

    # If there are no items, then we can delete the folder
    # Exluce folder: If (($subItems -eq $null) -and (-Not($path.contains("DfsrPrivate")))) 
    If ($subItems -eq $null) 
    {
        Write-Host "Removing empty folder '${path}'"
        Remove-Item -Force -Recurse:$removeHiddenFiles -LiteralPath $Path -testMode:$testMode
    }
}

# Run the script
Delete-EmptyFolder -path "C:\Users\malik kokcan\Documents"