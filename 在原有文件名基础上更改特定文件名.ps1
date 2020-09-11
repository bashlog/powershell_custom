param(
    # [Parameter(Mandatory = $true)]
    [string]$FilePath
)
$file = Get-ChildItem -Path $FilePath
foreach ($i in $file){
    $tt = $i.Name.Substring(4,19)
    Rename-Item -Path $i.FullName -NewName $tt
    #Write-Host($tt)
    #$i.LastWriteTime = $time
}