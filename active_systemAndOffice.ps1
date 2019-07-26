param(
    # Parameter help description
    [Parameter(Mandatory = $true)][string]$Version,
    [switch]$skipwinact
)
$ipAddress = (Get-NetIPAddress -InterfaceAlias 'VMware Network Adapter VMnet1' -AddressFamily IPv4).IPAddress + '28'
if (-not $skipwinact) {
    Start-Process -FilePath C:\Windows\System32\slmgr.vbs -ArgumentList /skms, $ipAddress -Wait 
    if ($Version -eq "pro") {
        Start-Process -FilePath C:\Windows\System32\slmgr.vbs -ArgumentList /ipk, W269N-WFGWX-YVC9B-4J6C9-T83GX -Wait 
    }
    if ($Version -eq "work") {
        Start-Process -FilePath C:\Windows\System32\slmgr.vbs -ArgumentList /ipk, NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J -Wait 
    }
    Start-Process -FilePath C:\Windows\System32\slmgr.vbs -ArgumentList /ato -Wait    
}
 
# Start-Process -FilePath D:\win_Script\activeOffice.bat -ArgumentList $ipAddress -Wait -WindowStyle Hidden 
Start-Process -FilePath $env:windir\System32\cscript.exe -ArgumentList "`"$env:ProgramFiles\Microsoft Office\Office16\OSPP.VBS`"", "/sethst:$ipAddress" -WindowStyle Hidden -Wait
Start-Process -FilePath $env:windir\System32\cscript.exe -ArgumentList "`"$env:ProgramFiles\Microsoft Office\Office16\OSPP.VBS`"", "/act" -WindowStyle Hidden -Wait 