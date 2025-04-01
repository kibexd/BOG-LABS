$containerName = 'boglabs'
$password = 'P@ssw0rd'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'OnPrem' -country 'w1' -select 'Latest'
$bcContainerHelperConfig.artifactDownloadTimeout = 3600
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -imageName 'boglabs:latest' `
    -multitenant `
    -memoryLimit 5G `
    -updateHosts `
