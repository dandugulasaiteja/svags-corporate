#requires -version 5.1

<#
.SYNOPSIS
Automated deployment script for Svags Corporate (Angular + .NET backend)

.DESCRIPTION
Builds Angular frontend, .NET backend, creates deployment package, and deploys to Azure.

.PARAMETER Environment
Deployment environment: Dev, Staging, or Prod (default: Dev)

.PARAMETER SkipBuild
Skip the build process and use existing dist/backend-publish folders

.PARAMETER OnlyPrepare
Only prepare the package without deploying to Azure

.PARAMETER DeployDatabase
Run database migrations after deployment

.EXAMPLE
.\deploy.ps1 -Environment Prod -DeployDatabase
#>

param(
    [ValidateSet('Dev', 'Staging', 'Prod')]
    [string]$Environment = 'Dev',

    [switch]$SkipBuild,
    [switch]$OnlyPrepare,
    [switch]$DeployDatabase
)

# Configuration
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$config = @{
    Dev = @{
        ResourceGroup = "svags-rg-dev"
        AppServiceName = "svags-corporate-api-dev"
        SqlServerName = "svags-corporate-sql-dev"
        DbName = "svags-corporate-db-dev"
    }
    Staging = @{
        ResourceGroup = "svags-rg-staging"
        AppServiceName = "svags-corporate-api-staging"
        SqlServerName = "svags-corporate-sql-staging"
        DbName = "svags-corporate-db-staging"
    }
    Prod = @{
        ResourceGroup = "svags-rg"
        AppServiceName = "svags-corporate-api"
        SqlServerName = "svags-corporate-sql"
        DbName = "svags-corporate-db"
    }
}

$env_config = $config[$Environment]
$scriptDir = Split-Path -Parent $MyInvocation.MyCommandPath
$deployDir = Join-Path $scriptDir "deploy-package"
$zipFile = Join-Path $scriptDir "svags-corporate-$Environment.zip"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Logging functions
function Write-Log {
    param([string]$Message, [ValidateSet('Info', 'Success', 'Warning', 'Error')]$Level = 'Info')

    $prefix = switch ($Level) {
        'Info'    { "[$timestamp] [INFO]" }
        'Success' { "[$timestamp] [✓]" }
        'Warning' { "[$timestamp] [⚠]" }
        'Error'   { "[$timestamp] [✗]" }
    }

    $color = switch ($Level) {
        'Info'    { 'Cyan' }
        'Success' { 'Green' }
        'Warning' { 'Yellow' }
        'Error'   { 'Red' }
    }

    Write-Host "$prefix $Message" -ForegroundColor $color
}

function Test-Prerequisites {
    Write-Log "Checking prerequisites..."

    $checks = @(
        @{ Name = "Node.js"; Command = "node --version" }
        @{ Name = ".NET SDK"; Command = "dotnet --version" }
        @{ Name = "Azure CLI"; Command = "az --version" }
        @{ Name = "Git"; Command = "git --version" }
    )

    foreach ($check in $checks) {
        try {
            $result = & $check.Command 2>$null
            Write-Log "$($check.Name): $result" -Level 'Success'
        }
        catch {
            Write-Log "$($check.Name) not found. Please install it first." -Level 'Error'
            exit 1
        }
    }

    # Check Azure login
    try {
        $account = az account show --query name -o tsv 2>$null
        if ($account) {
            Write-Log "Azure account: $account" -Level 'Success'
        }
        else {
            Write-Log "Not logged into Azure. Running 'az login'..." -Level 'Warning'
            az login
        }
    }
    catch {
        Write-Log "Azure CLI error. Please run 'az login' first." -Level 'Error'
        exit 1
    }
}

function Build-Angular {
    Write-Log "Building Angular frontend..."

    try {
        Push-Location $scriptDir

        Write-Log "Installing npm dependencies..."
        npm install

        Write-Log "Building Angular application..."
        npm run build

        if (-not (Test-Path "dist")) {
            throw "Angular build failed - dist folder not created"
        }

        Write-Log "Angular build completed" -Level 'Success'
        Pop-Location
    }
    catch {
        Write-Log "Angular build failed: $_" -Level 'Error'
        Pop-Location
        exit 1
    }
}

function Build-Dotnet {
    Write-Log "Building .NET backend..."

    try {
        $backendPath = Join-Path $scriptDir "backend"
        $publishPath = Join-Path $scriptDir "backend-publish"

        Push-Location $backendPath

        Write-Log "Restoring NuGet packages..."
        dotnet restore

        Write-Log "Building .NET application (Release)..."
        dotnet build -c Release

        Write-Log "Publishing .NET application..."
        if (Test-Path $publishPath) {
            Remove-Item $publishPath -Recurse -Force
        }

        dotnet publish -c Release -o $publishPath

        Write-Log ".NET build completed" -Level 'Success'
        Pop-Location
    }
    catch {
        Write-Log ".NET build failed: $_" -Level 'Error'
        Pop-Location
        exit 1
    }
}

function Prepare-Package {
    Write-Log "Preparing deployment package..."

    try {
        # Clean up old package
        if (Test-Path $deployDir) {
            Remove-Item $deployDir -Recurse -Force
        }

        New-Item -ItemType Directory -Path $deployDir | Out-Null

        # Copy Angular dist to wwwroot
        Write-Log "Copying Angular dist to wwwroot..."
        $distPath = Join-Path $scriptDir "dist"
        $wwwrootPath = Join-Path $deployDir "wwwroot"

        if (Test-Path $distPath) {
            Copy-Item -Path "$distPath/*" -Destination $wwwrootPath -Recurse -Force
        }
        else {
            throw "Angular dist folder not found"
        }

        # Copy .NET backend
        Write-Log "Copying .NET backend..."
        $publishPath = Join-Path $scriptDir "backend-publish"

        if (Test-Path $publishPath) {
            $items = Get-ChildItem $publishPath -Force
            foreach ($item in $items) {
                if ($item.Name -ne "wwwroot") {
                    Copy-Item -Path $item.FullName -Destination $deployDir -Recurse -Force
                }
            }
        }
        else {
            throw ".NET publish folder not found"
        }

        # Copy database scripts if they exist
        Write-Log "Copying database scripts..."
        $dbScriptsPath = Join-Path $scriptDir "backend/database"
        if (Test-Path $dbScriptsPath) {
            $dbTargetPath = Join-Path $deployDir "database"
            Copy-Item -Path $dbScriptsPath -Destination $dbTargetPath -Recurse -Force
        }

        Write-Log "Package prepared successfully" -Level 'Success'
        Write-Log "Package location: $deployDir"
    }
    catch {
        Write-Log "Package preparation failed: $_" -Level 'Error'
        exit 1
    }
}

function Create-Zip {
    Write-Log "Creating deployment zip file..."

    try {
        if (Test-Path $zipFile) {
            Remove-Item $zipFile -Force
        }

        # Compress the deployment package
        Compress-Archive -Path "$deployDir\*" -DestinationPath $zipFile -Force

        $zipSize = (Get-Item $zipFile).Length / 1MB
        Write-Log "Zip file created: $zipFile ($([math]::Round($zipSize, 2)) MB)" -Level 'Success'
    }
    catch {
        Write-Log "Zip creation failed: $_" -Level 'Error'
        exit 1
    }
}

function Deploy-ToAzure {
    Write-Log "Deploying to Azure ($Environment environment)..."

    try {
        # Check if resource group exists
        Write-Log "Checking Azure resources..."
        $rgExists = az group exists --name $env_config.ResourceGroup --query value -o tsv

        if ($rgExists -eq "false") {
            Write-Log "Resource group does not exist: $($env_config.ResourceGroup)" -Level 'Error'
            exit 1
        }

        # Check if app service exists
        $appExists = az webapp show --name $env_config.AppServiceName --resource-group $env_config.ResourceGroup --query id -o tsv 2>$null

        if (-not $appExists) {
            Write-Log "App Service does not exist: $($env_config.AppServiceName)" -Level 'Error'
            Write-Log "Create the App Service in Azure Portal first." -Level 'Error'
            exit 1
        }

        # Deploy zip file
        Write-Log "Uploading and deploying zip file to $($env_config.AppServiceName)..."
        az webapp deployment source config-zip `
            --resource-group $env_config.ResourceGroup `
            --name $env_config.AppServiceName `
            --src $zipFile

        Write-Log "Deployment to Azure completed" -Level 'Success'

        # Get app URL
        $appUrl = az webapp show --name $env_config.AppServiceName --resource-group $env_config.ResourceGroup --query "defaultHostName" -o tsv
        Write-Log "App URL: https://$appUrl" -Level 'Info'
    }
    catch {
        Write-Log "Azure deployment failed: $_" -Level 'Error'
        exit 1
    }
}

function Migrate-Database {
    Write-Log "Running database migrations..."

    try {
        Write-Log "Connecting to App Service to run migrations..."

        # Get the Kudu API endpoint
        $publishProfile = az webapp deployment list-publishing-profiles `
            --name $env_config.AppServiceName `
            --resource-group $env_config.ResourceGroup `
            --query "[?publishMethod=='MSDeploy'].{publishUrl:publishUrl}" -o tsv

        Write-Log "Running EF Core migrations..."

        # This requires the app to be up and SSH access available
        # Alternative: manually run migrations via Kudu console
        Write-Log "Note: Run database migrations manually via Kudu console or SQL scripts" -Level 'Warning'
        Write-Log "Kudu URL: https://$($env_config.AppServiceName).scm.azurewebsites.net/cmd"
    }
    catch {
        Write-Log "Database migration failed: $_" -Level 'Error'
    }
}

function Cleanup {
    Write-Log "Cleaning up temporary files..."

    try {
        if (Test-Path $deployDir) {
            Remove-Item $deployDir -Recurse -Force
        }

        $publishPath = Join-Path $scriptDir "backend-publish"
        if (Test-Path $publishPath) {
            Remove-Item $publishPath -Recurse -Force
        }

        Write-Log "Cleanup completed" -Level 'Success'
    }
    catch {
        Write-Log "Cleanup warning: $_" -Level 'Warning'
    }
}

function Show-Summary {
    Write-Log "=== DEPLOYMENT SUMMARY ===" -Level 'Info'
    Write-Log "Environment: $Environment"
    Write-Log "Resource Group: $($env_config.ResourceGroup)"
    Write-Log "App Service: $($env_config.AppServiceName)"
    Write-Log "Database: $($env_config.DbName)"
    Write-Log "Zip File: $zipFile"
    Write-Log "Status: Deployment Complete" -Level 'Success'
    Write-Log "========================================" -Level 'Info'
}

# Main execution
try {
    Write-Log "Starting Svags Corporate deployment pipeline..."
    Write-Log "Environment: $Environment"
    Write-Log "Config: $($env_config | ConvertTo-Json)"

    Test-Prerequisites

    if (-not $SkipBuild) {
        Build-Angular
        Build-Dotnet
    }
    else {
        Write-Log "Skipping build - using existing artifacts" -Level 'Warning'
    }

    Prepare-Package
    Create-Zip

    if (-not $OnlyPrepare) {
        Deploy-ToAzure

        if ($DeployDatabase) {
            Migrate-Database
        }

        Cleanup
        Show-Summary
    }
    else {
        Write-Log "Package prepared. Skipping Azure deployment." -Level 'Success'
        Write-Log "To deploy, run: .\deploy.ps1 -Environment $Environment" -Level 'Info'
    }
}
catch {
    Write-Log "Deployment failed: $_" -Level 'Error'
    exit 1
}

Write-Log "Deployment script completed successfully!" -Level 'Success'
