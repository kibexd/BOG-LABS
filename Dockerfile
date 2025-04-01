FROM boglabs:latest

# Copy the AL app to the container
WORKDIR /run/my/

# Copy the AL app to the container
COPY ./app-package/*.app .

# Install the app (using a script that will be executed when the container starts)
RUN powershell -Command \
    $startScript = '@echo off\n'; \
    $startScript += 'powershell -Command "'; \
    $startScript += 'Start-Sleep -Seconds 10; '; \
    $startScript += 'Import-Module ''C:/Program Files/Microsoft Dynamics NAV/*/Service/NavAdminTool.ps1'' -WarningAction SilentlyContinue; '; \
    $startScript += 'Write-Host \"Installing Business Central App...\"; '; \
    $startScript += 'Get-ChildItem -Path ''/run/my/*.app'' | ForEach-Object { '; \
    $startScript += '  $appPath = $_.FullName; '; \
    $startScript += '  Write-Host \"Publishing app: $appPath\"; '; \
    $startScript += '  Publish-NAVApp -ServerInstance BC -Path $appPath -SkipVerification; '; \
    $startScript += '  $appInfo = Get-NAVAppInfo -ServerInstance BC -Path $appPath; '; \
    $startScript += '  Write-Host \"Syncing app: $($appInfo.Name)\"; '; \
    $startScript += '  Sync-NAVApp -ServerInstance BC -Name $appInfo.Name -Version $appInfo.Version; '; \
    $startScript += '  Write-Host \"Installing app: $($appInfo.Name)\"; '; \
    $startScript += '  Install-NAVApp -ServerInstance BC -Name $appInfo.Name -Version $appInfo.Version; '; \
    $startScript += '}; '; \
    $startScript += 'Write-Host \"Installation complete!\"; '; \
    $startScript += '"'; \
    Set-Content -Path /run/start.ps1 -Value $startScript