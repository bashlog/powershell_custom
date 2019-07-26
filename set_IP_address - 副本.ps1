if (-not ((Get-ExecutionPolicy).value__ -eq "1")) {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force 
}
Get-NetAdapter -Physical | ForEach-Object {
    if ($_.Status -eq "Up") {
        if ($_.InterfaceDescription -eq "Intel(R) 82579LM Gigabit Network Connection") {
            Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $_.ifAlias | Format-Table -Property IPAddress,PrefixLength
            $ipAddress = Read-Host "请输入 IP 地址"
            $getway = Read-Host "请输入网关地址"
            $netmask = Read-Host "请输入掩码长度（例如：8、16、24）"
            New-NetIPAddress -IPAddress "$ipAddress" -InterfaceAlias $_.InterfaceAlias -DefaultGateway "$getway" -AddressFamily IPv4 -PrefixLength $netmask 
            Set-DnsClientServerAddress -InterfaceAlias $_.InterfaceAlias -ServerAddresses "202.99.96.68"
        }
        
    }
}

#Get-NetAdapter -Physical | ForEach-Object {
 #   if ($_.InterfaceDescription -eq "Intel(R) 82579LM Gigabit Network Connection") {
#        Set-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6 -Enabled $false
        
#    }
#}
Read-Host "huah"