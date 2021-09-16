# build "server" image
FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine

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
RUN dotnet test -c Release

# deploy
RUN dotnet publish -c Release -o /dist


# production runtime "server" image
FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine

ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_URLS http://+:80
EXPOSE 80

WORKDIR /app
COPY --from=build /dist .

CMD ["dotnet", "BuildScriptToDockerfile.dll"]
