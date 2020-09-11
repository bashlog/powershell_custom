param(
    # [switch]$vmware,
    # [Parameter(Mandatory = $true)][string]$Version,
    # [switch]$firefox
    # [switch]$foxit,
    # [switch]$soGou,
    # [switch]$Drcom,
    # [switch]$putty,
    [string]$DirPath
)
$dict = @{}
Get-ChildItem -Path $DirPath -Recurse | ForEach-Object {
        
        $hash = ($_ | Get-FileHash -Algorithm SHA1).Hash
        if ($dict.ContainsKey($hash))
        {
            [PSCustomObject]@{
                Original = $dict[$hash]
                Duplicate = $_.FullName
                }
        }
        else
        {
            $dict[$hash]=$_.FullName
        }
    } |
    Out-GridView