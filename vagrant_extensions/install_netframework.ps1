param (
    [Parameter(Mandatory=$true)]
    [string]$version
)

# Define the URL for the .NET Framework installer
$installerUrl = "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp$version-x86-x64-allos-enu.exe"

Write-Host "Installer URL: $installerUrl"

# Define the path to save the installer
$installerPath = "$env:TEMP\ndp$version-setup.exe"

Write-Host "Installer will be saved to: $installerPath"

# Download the installer
Write-Host "Downloading installer..."
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

Write-Host "Download complete."

# Run the installer in unattended mode
Write-Host "Running installer in unattended mode..."
Start-Process -FilePath $installerPath -ArgumentList '/q /norestart' -Wait

Write-Host "Installation complete."
