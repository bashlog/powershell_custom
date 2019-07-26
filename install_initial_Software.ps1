param(
    # [switch]$vmware,
    # [Parameter(Mandatory = $true)][string]$Version,
    [switch]$firefox
    # [switch]$foxit,
    # [switch]$soGou,
    # [switch]$Drcom,
    # [switch]$putty
)
# 必须进行的操作
if (-not ((Get-ExecutionPolicy).value__ -eq "1" )) {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
}
$WshShell = New-Object -ComObject WScript.Shell
$isoFile = Read-Host "请输入ISO文件的路径"
if (-not ($null -eq $isoFile)) {
    Mount-DiskImage -ImagePath $isoFile -StorageType ISO -Access ReadOnly
    
}
<# 
Get-NetAdapter | ForEach-Object {
    IF ($_.Name -eq "WLAN") {
        # Set-NetAdapterBinding -Name "WLAN" -ComponentID ms_tcpip6 -Enabled $false
        # Set-DnsClientServerAddress -InterfaceAlias "WLAN" -ServerAddresses "180.76.76.76", "101.6.6.6" 
    }
    IF ($_.Name -eq "以太网") {
        Set-NetAdapterBinding -Name "以太网" -ComponentID ms_tcpip6 -Enabled $false
        Set-DnsClientServerAddress -InterfaceAlias "以太网" -ServerAddresses "180.76.76.76", "101.6.6.6"
    }
}
#>
Get-NetAdapter -Physical | ForEach-Object {
    if ($_.InterfaceDescription -eq "Realtek PCIe GBE Family Controller") {
        # Set-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6 -Enabled $false
        New-NetIPAddress -IPAddress "192.168.6.145" -InterfaceAlias $_.InterfaceAlias -DefaultGateway "192.168.6.1" -AddressFamily IPv4 -PrefixLength 24 
        Set-DnsClientServerAddress -InterfaceAlias $_.InterfaceAlias -ServerAddresses "202.99.96.68"
    }
}
$yy = (Get-WmiObject win32_computersystem | Select-Object name).name
$share_path = Read-Host "请输入将要共享的目录"
if (-not ($null -eq $share_path)) {
    New-SmbShare -Name Share -Path $share_path -FullAccess "$yy\$env:USERNAME" -AsJob
}
$driverPath = Read-Host "请输入驱动包（zip 压缩包）的路径"
if (-not ($null -eq $driverPath)) {
    Expand-Archive -Path $driverPath -DestinationPath "$HOME\Documents"
}
#
#
# IF ((Test-Path -Path D:\ISO_Files\cn_windows_10_consumer_editions_version_1803\sources\sxs\microsoft-windows-netfx3-ondemand-package~31bf3856ad364e35~amd64~~.cab) -and (Test-Path -Path D:\ISO_Files\cn_windows_10_consumer_editions_version_1803\sources\sxs\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~zh-CN~.cab)) {
#    & dism /Online /enable-feature /featureName:netfx3 /all /limitAccess /source:"D:\ISO_Files\cn_windows_10_consumer_editions_version_1803\sources\sxs"
# } ELSE {
#    Write-Output 'NET3.5安装包不存在！请查明安装包位置。'
#    Write-Output 'NET3.5功能将不被安装！'
# }
Get-Volume | ForEach-Object {
    IF ($_.DriveType -eq 'CD-ROM') {
        $hua = $_.DriveLetter + ':'
        # Start-Process -FilePath $hua\setup.exe -ArgumentList /adminfile, D:\win_Script\Office_install_without_person.MSP -Wait -WindowStyle Hidden 
        Start-Process -FilePath $hua\setup.exe
    }
}
$potplayerPath = Read-Host "请输入Potplayer安装软件的路径（文件夹）"
if (-not ($null -eq $potplayerPath)) {
    Start-Process -FilePath $potplayerPath\PotPlayerSetup64.exe -Wait 
    Start-Process -FilePath $potplayerPath\OpenCodecSetup64.exe -Wait 
    Copy-Item -Path $potplayerPath\2_tst2.0_黑.dsf -Destination "$env:ProgramFiles\DAUM\PotPlayer\Skins"
}
if (-not ($null -eq $isoFile)) {
    Dismount-DiskImage -ImagePath $isoFile -StorageType ISO
    
}
$vscodePath = Read-Host "请输入 VSCode 安装包文件的位置"
if (-not ($null -eq $vscodePath)) {
    Start-Process -FilePath $vscodePath -Wait
    
}
IF (-not (Test-Path -Path $HOME\AppData\Roaming\Code\User)) {
    mkdir $HOME\AppData\Roaming\Code\User
}
$vscode_setingPath = Read-Host "请输入 VS code 的设置文件（ json 文件）"
if (-not ($null -eq $vscode_setingPath)) {
    Copy-Item -Path $vscode_setingPath -Destination $HOME\AppData\Roaming\Code\User
    
}
$jdkPath = Read-Host "请输入 jdk 安装文件的路径"
if (-not ($null -eq $jdkPath)) {
    Start-Process -FilePath $jdkPath -Wait
    [Environment]::SetEnvironmentVariable('JAVA_HOME', "$env:ProgramFiles\Java\jdk1.8.0_172", [EnvironmentVariableTarget]::Machine)
    [Environment]::SetEnvironmentVariable('CLASSPATH', '.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar', [EnvironmentVariableTarget]::Machine)
    $path_bianLiang1 = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
    $path_bianLiang2 = $path_bianLiang1 + ';%JAVA_HOME%\bin' + ";${env:ProgramFiles(x86)}\VMware\VMware VIX"
    [Environment]::SetEnvironmentVariable('Path', $path_bianLiang2, [EnvironmentVariableTarget]::Machine)
    
}
#
#
IF ($firefox) {
    $firefoxPath = Read-Host "请输入 Firefox 安装脚本的路径"
    if (-not ($null -eq $firefoxPath)) {
        Start-Process -FilePath $firefoxPath -Wait 
    }
}
# IF ($vmware) {
# Start-Process -FilePath D:\win_Script\vmware_install_without_person.bat -Wait -WindowStyle Hidden
# $path_bianLiang3 = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
# $path_bianLiang4 = $path_bianLiang3 + ";${env:ProgramFiles(x86)}\VMware\VMware VIX"
# [Environment]::SetEnvironmentVariable('Path', $path_bianLiang4, [EnvironmentVariableTarget]::Machine)
# & 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VMware\VMware Workstation Pro.lnk'
# }
# IF ($foxit) {
# Start-Process -FilePath D:\Web_Downloads\foxit_FoxitInst.exe -Wait 
# }
IF ($soGou) {
    Start-Process -FilePath D:\Web_Downloads\sogou_pinyin_89c.exe -Wait 
}
IF ($putty) {
    mkdir "$HOME\AppData\Local\Microsoft\WindowsApps\putty"
    Expand-Archive -Path D:\Web_Downloads\portable-putty-x64-0.70cn.zip -DestinationPath "$HOME\AppData\Local\Microsoft\WindowsApps\putty"
    mkdir "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Putty"
    $lnk1 = $WshShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Putty\putty.lnk")
    $lnk1.TargetPath = "$HOME\AppData\Local\Microsoft\WindowsApps\putty\putty.exe"
    $lnk1.Save()
}
#
#
IF (-not ($null -eq (Get-ScheduledTask -TaskPath \ -ErrorAction Ignore).TaskName )) {
    Get-ScheduledTask -TaskPath \ | Disable-ScheduledTask
}

# & "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Control Panel.lnk"
Write-Output 'D:\win_Script\vmcopy_file_to_guest.bat'
Write-Output 'D:\win_Script\active_systemAndOffice.ps1'
