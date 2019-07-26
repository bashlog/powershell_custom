param(
    #    [string]$version
    [switch]$soGou,
    [switch]$foxit,
    [switch]$putty,
    [switch]$firefox,
    [switch]$jdk,
    # [switch]$samba_job
)
# Remove-Item -Path C:\AMD -Recurse -Force 
& dism /Online /enable-feature /featureName:netfx3 /all /limitAccess /source:"D:\ISO_Files\cn_windows_10_consumer_editions_version_1803_updated_march_2018_x64_dvd_12063766\sources\sxs"
#if ($samba_job) {
$yy = (Get-WmiObject win32_computersystem | Select-Object name).name
New-SmbShare -Name Share -Path D:\Share_Samba -FullAccess "$yy\BrightAlan" -AsJob
#}
Mount-DiskImage -ImagePath D:\ISO_Files\SW_DVD5_Office_Professional_Plus_2016_64Bit_ChnSimp_MLF_X20-42426.ISO -StorageType ISO -Access ReadOnly 
Get-NetAdapter | ForEach-Object {
    if ($_.Name -eq "WLAN") {
        Set-NetAdapterBinding -Name "WLAN" -ComponentID ms_tcpip6 -Enabled $false
        Set-DnsClientServerAddress -InterfaceAlias "WLAN" -ServerAddresses "180.76.76.76", "101.6.6.6"
    }
    if ($_.Name -eq "以太网") {
        Set-NetAdapterBinding -Name "以太网" -ComponentID ms_tcpip6 -Enabled $false
        Set-DnsClientServerAddress -InterfaceAlias "以太网" -ServerAddresses "180.76.76.76", "101.6.6.6"
    }
}
$WshShell = New-Object -ComObject WScript.Shell
# $batfile=[diagnostics.process]::Start("D:\vmware_install_without_person.bat")
# $batfile.WaitForExit()
# Write-Output "VMware 安装完成！"
Start-Process -FilePath D:\win_Script\vmware_install_without_person.bat -Wait -WindowStyle Hidden 
Get-Volume | ForEach-Object {
    IF ($_.DriveType -eq 'CD-ROM') {
        $hua = $_.DriveLetter + ':'
        Start-Process -FilePath $hua\setup.exe -ArgumentList /adminfile, D:\win_Script\Office_install_without_person.MSP -Wait -WindowStyle Hidden 
    }
}
# 安装火狐浏览器
if ($firefox) {
    Start-Process -FilePath D:\win_Script\firefox_without_person_install.bat -WindowStyle Hidden -Wait 
}
Dismount-DiskImage -ImagePath D:\ISO_Files\SW_DVD5_Office_Professional_Plus_2016_64Bit_ChnSimp_MLF_X20-42426.ISO -StorageType ISO 
# 安装potplayer
Start-Process -FilePath D:\Appliations\Potplayer\PotPlayerSetup64.exe -Wait 
Start-Process -FilePath D:\Appliations\Potplayer\OpenCodecSetup64.exe -Wait 
Copy-Item -Path D:\Appliations\Potplayer\2_tst2.0_黑.dsf -Destination "$env:ProgramFiles\DAUM\PotPlayer\Skins"
# IF (-not (Test-Path -Path $HOME\AppData\Roaming\PotPlayerMini64)) {
# mkdir $HOME\AppData\Roaming\PotPlayerMini64
# }
# Copy-Item -Path D:\Appliations\Potplayer\PotPlayerMini64.ini -Destination $HOME\AppData\Roaming\PotPlayerMini64\PotPlayerMini64.ini 
# 安装福昕PDF阅读器
IF ($foxit) {
    Start-Process -FilePath D:\Web_Downloads\foxit_FoxitInst.exe -Wait 
}
# 安装VSCode编辑器
Start-Process -FilePath D:\Web_Downloads\VSCodeSetup-x64-1.22.1.exe -Wait
if (-not (Test-Path -Path $HOME\AppData\Roaming\Code\User)) {
    mkdir $HOME\AppData\Roaming\Code\User
}
Copy-Item -Path D:\Appliations\settings.json -Destination $HOME\AppData\Roaming\Code\User    
#if (-not (Test-Path -Path $HOME\.vscode\extensions)) {
 #   mkdir $HOME\.vscode\extensions
#}
#Copy-Item -Path D:\Appliations\extensions\ms-vscode.powershell-1.7.0 -Destination $HOME\.vscode\extensions -Force -Recurse 
# 安装搜狗输入法
IF ($soGou) {
    Start-Process -FilePath D:\Web_Downloads\sogou_pinyin_89c.exe -Wait 
}
# 校园网拨号软件
if ($Drcom) {
    Copy-Item -Path D:\Drcom -Destination "${env:ProgramFiles(x86)}" -Force -Recurse 
    $lnk = $WshShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\DrMain.lnk")
    $lnk.TargetPath = "${env:ProgramFiles(x86)}\Drcom\DrMain.exe"
    $lnk.Save()
}
# Copy-Item -Path D:\Appliations\关机.vbs -Destination $HOME\Desktop 
# 安装 PUTTY ssh客户端
IF ($putty) {
    mkdir "$HOME\AppData\Local\Microsoft\WindowsApps\putty"
    Expand-Archive -Path D:\Web_Downloads\portable-putty-x64-0.70cn.zip -DestinationPath "$HOME\AppData\Local\Microsoft\WindowsApps\putty"
    mkdir "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Putty"
    $lnk1 = $WshShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Putty\putty.lnk")
    $lnk1.TargetPath = "$HOME\AppData\Local\Microsoft\WindowsApps\putty\putty.exe"
    $lnk1.Save()
}
# 安装jdk
if ($jdk) {
    Start-Process -FilePath D:\Appliations\jdk-8u172-windows-x64.exe -Wait 
}
IF (-not ((Get-ScheduledTask -TaskPath \ -ErrorAction Ignore).TaskName -eq $null)) {
    Get-ScheduledTask -TaskPath \ | Disable-ScheduledTask
}
# Write-Output 'VMware、Office、Firefox、potplayer、vscode 和 搜狗拼音输入法 、福昕PDF编辑器 安装完成！'
[Environment]::SetEnvironmentVariable('JAVA_HOME', "$env:ProgramFiles\Java\jdk1.8.0_172", [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable('CLASSPATH', '.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar', [EnvironmentVariableTarget]::Machine)
$path_bianLiang1 = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
$path_bianLiang2 = $path_bianLiang1 + ';%JAVA_HOME%\bin'+";${env:ProgramFiles(x86)}\VMware\VMware VIX"
[Environment]::SetEnvironmentVariable('Path', $path_bianLiang2, [EnvironmentVariableTarget]::Machine)
Copy-Item -Path D:\Appliations\Hello.java -Destination $HOME\Desktop
# 启动 VMware 虚拟机管理软件
#if (-not (Test-Path -Path "$HOME\AppData\Roaming\VMware")) {
#    New-Item -Path "$HOME\AppData\Roaming" -Name VMware -ItemType Directory 
#}
#Copy-Item -Path D:\Appliations\preferences.ini -Destination "$HOME\\AppData\Roaming\VMware"
#Start-Process -FilePath D:\win_Script\vmcopy_file_to_guest.bat -Wait -WindowStyle Hidden 
# @"C:\Program Files (x86)\VMware\VMware VIX\vmrun.exe" -T ws -gu root -gp 123456 getGuestIPAddress
& 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VMware\VMware Workstation Pro.lnk'
& "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Control Panel.lnk"
#Start-Process -FilePath D:\win_Script\active_systemAndOffice.ps1 -Wait
# & 'C:\Windows\System32\Taskmgr.exe'
