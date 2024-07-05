# Use the official .NET 7 SDK image as a build environment
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy the .csproj file and restore as distinct layers
COPY ["api_form.csproj", "./"]
RUN dotnet restore "api_form.csproj"

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out --no-restore

# Use the official .NET runtime image as the runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

# Set the entry point for the container
ENTRYPOINT ["dotnet", "api_form.dll"]
