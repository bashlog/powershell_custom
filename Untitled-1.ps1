Get-Volume | ForEach-Object {
    IF($_.DriveType -eq 'Fixed'){
        # Start-Process -FilePath "$_.DriveLetter"+:\Users\BrightAlan\temp.txt
        $jo=$_.DriveLetter+':'
        Write-Output $jo
    }
}
# Get-Volume | while  {
    
# }