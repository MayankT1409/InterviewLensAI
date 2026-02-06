$target = [EnvironmentVariableTarget]::User
$path = [Environment]::GetEnvironmentVariable('Path', $target)
$emulatorPath = 'C:\Android\Sdk\emulator'
if (-not ($path -split ';' | Where-Object { $_ -eq $emulatorPath })) {
    $newPath = $path + ';' + $emulatorPath
    [Environment]::SetEnvironmentVariable('Path', $newPath, $target)
    Write-Host "Success: Added $emulatorPath to User PATH."
} else {
    Write-Host "Info: $emulatorPath is already in User PATH."
}
