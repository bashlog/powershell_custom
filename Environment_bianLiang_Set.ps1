param([string]$bianLiangZhi)
$test_temp=[Environment]::GetEnvironmentVariable('Path')
$newPath=$test_temp+";"+$bianLiangZhi
[Environment]::SetEnvironmentVariable("Path",$newPath,[EnvironmentVariableTarget]::Machine)
# [Environment]::GetEnvironmentVariable("Path")