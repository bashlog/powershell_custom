param(
    # [Parameter(Mandatory = $true)]
    [string]$FilePath
)
$file = Get-ChildItem -Path $FilePath 
foreach ($i in $file){
    [String] $time = $i.Name.Substring(11,10) + ' ' + $i.Name.Substring(22,2) + ':' + $i.Name.Substring(25,2) + ':' + $i.Name.Substring(28,2)
#    Write-Host($time)
    $i.LastWriteTime = $time
}