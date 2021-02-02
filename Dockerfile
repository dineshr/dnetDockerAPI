#Get base SDK image from Microsoft
FROM mcr.Microsoft.com/dotnet/sdk:5.0-alpine AS build-env
WORKDIR /app


# Copy the .csproj file and restore any dependencies (via Nuget)
COPY dnetDockerAPI.csproj ./
RUN dotnet restore "./dnetDockerAPI.csproj"

# Copy the project files and build our release
COPY . ./
RUN dotnet publish -c Release -o out

# Generate runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine
WORKDIR /app
EXPOSE 80
EXPOSE 443
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "dnetDockerAPI.dll"]
