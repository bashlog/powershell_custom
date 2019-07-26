$dict = @{}
Get-ChildItem -Path $home -Filter *.ps1 -Recurse |
    ForEach-Object {
        $hash = ($_ | Get-FileHash -Algorithm MD5).Hash
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