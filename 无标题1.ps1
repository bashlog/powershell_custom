$path_bianLiang1 = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
$path_bianLiang2 = $path_bianLiang1 + ';%JAVA_HOME%\bin'
[Environment]::SetEnvironmentVariable('Path', $path_bianLiang2, [EnvironmentVariableTarget]::Machine)