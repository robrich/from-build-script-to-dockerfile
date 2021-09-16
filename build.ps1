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
dotnet test -c Release

# deploy
dotnet publish -c Release -o dist
Compress-Archive -Path dist -DestinationPath BuildScriptToDockerfile.zip
# TODO: copy to target server and unzip

git checkout .\Properties\AssemblyInfo.cs
