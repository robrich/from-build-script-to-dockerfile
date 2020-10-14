# build server
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine as build

RUN apk add git

WORKDIR /src
COPY BuildScriptToDockerfile.csproj .
RUN dotnet restore

COPY . .
# version assets
RUN GITHASH=`git rev-parse --short HEAD`; \
    sed -i'' -e "s/GITHASH/$GITHASH/g" Properties/AssemblyInfo.cs; \
    echo "Git hash: $GITHASH"

# build
RUN dotnet build -c Release

# test
RUN dotnet test

# deploy
RUN dotnet publish -c Release -o dist


# production server
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine

ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_URLS http://+:80
EXPOSE 80

WORKDIR /app
COPY --from=build /src/dist .

CMD ["dotnet", "BuildScriptToDockerfile.dll"]
