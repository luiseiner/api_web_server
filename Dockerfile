# Use the official .NET 7 SDK image as a build environment
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copiar todos los archivos al contenedor
COPY . .

# Restaurar dependencias de manera manual (esto es un ejemplo y probablemente no funcione para proyectos reales)
RUN dotnet new webapi -o /app
RUN dotnet add package Microsoft.AspNetCore.OpenApi --version 7.0.19
RUN dotnet add package OpenAI --version 1.11.0
RUN dotnet add package Swashbuckle.AspNetCore --version 6.5.0

# Construir el proyecto
RUN dotnet build -c Release

# Publicar el proyecto
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image as the runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

# Configurar el punto de entrada del contenedor
ENTRYPOINT ["dotnet", "api_form.dll"]
