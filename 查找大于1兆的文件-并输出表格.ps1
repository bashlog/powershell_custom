param(
    # [Parameter(Mandatory = $true)]
    [string]$FilePath
) 

Get-ChildItem -Path $FilePath -Recurse -File | ForEach-Object {
    if($_.Length -ge 1MB){
        [PSCustomObject]@{
            Original = $_.Length/1MB
            Duplicate = $_.FullName
        }
    }
} | Out-GridView

