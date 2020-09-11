param(
    # [Parameter(Mandatory = $true)]
    [string]$FilePath
)
# $FilePath = Read-Host "input file path:"
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

$fileString = Get-ChildItem -Path $FilePath -Recurse -File -Force
foreach($i in $fileString){
    if($i.Length -gt 1MB){
        # Write-Host "haha"
        # Write-Host $i.FullName
        Copy-Item -Path $i.FullName -Destination $HOME\Desktop -Force
    }
}