## BUILD SCRIPT FOR OUR WEBSITE
## ============================

$ErrorActionPreference = "Stop"

# source control
git pull
git checkout
git reset --hard
git clean -fdX

# version assets
(Get-Content Properties\AssemblyInfo.cs).replace('GITHASH', (git rev-parse --short HEAD)) | Set-Content Properties\AssemblyInfo.cs

# build
dotnet restore
dotnet build -c Release

# test
dotnet test

# deploy
dotnet publish -c Release -o dist
Compress-Archive -Path dist -DestinationPath BuildScriptToDockerfile.zip
robocopy /mir dist server # TODO: set to UNC path of destination machine
