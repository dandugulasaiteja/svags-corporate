#requires -version 5.1

<#
.SYNOPSIS
Setup Azure resources for Svags Corporate deployment

.DESCRIPTION
Creates App Service, SQL Database, and related resources in Azure Portal.
Run this BEFORE running deploy.ps1

.PARAMETER Environment
Environment to setup: Dev, Staging, or Prod (default: Dev)

.PARAMETER SqlAdminPassword
Password for SQL Server admin (if not provided, will prompt)

.EXAMPLE
.\setup-azure-resources.ps1 -Environment Dev
#>

param(
    [ValidateSet('Dev', 'Staging', 'Prod')]
    [string]$Environment = 'Dev',

    [string]$SqlAdminPassword
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Load configuration
$configPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommandPath) "deploy-config.json"
$allConfigs = Get-Content $configPath | ConvertFrom-Json
$config = $allConfigs.$Environment

# Logging functions
function Write-Log {
    param([string]$Message, [ValidateSet('Info', 'Success', 'Warning', 'Error')]$Level = 'Info')

    $prefix = switch ($Level) {
        'Info'    { "[INFO]" }
        'Success' { "[✓]" }
        'Warning' { "[⚠]" }
        'Error'   { "[✗]" }
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

    try {
        $version = az --version 2>$null
        Write-Log "Azure CLI found" -Level 'Success'
    }
    catch {
        Write-Log "Azure CLI not found. Please install it first." -Level 'Error'
        exit 1
    }

    # Check Azure login
    try {
        $account = az account show --query name -o tsv 2>$null
        if ($account) {
            Write-Log "Logged in as: $account" -Level 'Success'
        }
        else {
            throw "Not logged in"
        }
    }
    catch {
        Write-Log "Not logged into Azure. Running 'az login'..." -Level 'Warning'
        az login
    }
}

function Create-ResourceGroup {
    Write-Log "Creating resource group: $($config.resourceGroup)..."

    try {
        $exists = az group exists --name $config.resourceGroup --query value -o tsv

        if ($exists -eq "true") {
            Write-Log "Resource group already exists" -Level 'Warning'
            return
        }

        az group create `
            --name $config.resourceGroup `
            --location $config.location `
            --tags $($config.tags | ConvertTo-Json -Compress)

        Write-Log "Resource group created" -Level 'Success'
    }
    catch {
        Write-Log "Failed to create resource group: $_" -Level 'Error'
        exit 1
    }
}

function Create-AppServicePlan {
    Write-Log "Creating App Service Plan: $($config.appServicePlan)..."

    try {
        $exists = az appservice plan show `
            --name $config.appServicePlan `
            --resource-group $config.resourceGroup `
            --query id -o tsv 2>$null

        if ($exists) {
            Write-Log "App Service Plan already exists" -Level 'Warning'
            return
        }

        az appservice plan create `
            --name $config.appServicePlan `
            --resource-group $config.resourceGroup `
            --sku $config.appServiceSku `
            --is-linux

        Write-Log "App Service Plan created" -Level 'Success'
    }
    catch {
        Write-Log "Failed to create App Service Plan: $_" -Level 'Error'
        exit 1
    }
}

function Create-AppService {
    Write-Log "Creating App Service: $($config.appServiceName)..."

    try {
        $exists = az webapp show `
            --name $config.appServiceName `
            --resource-group $config.resourceGroup `
            --query id -o tsv 2>$null

        if ($exists) {
            Write-Log "App Service already exists" -Level 'Warning'
            Configure-AppService
            return
        }

        az webapp create `
            --name $config.appServiceName `
            --resource-group $config.resourceGroup `
            --plan $config.appServicePlan `
            --runtime "DOTNETCORE|10.0" `
            --tags $($config.tags | ConvertTo-Json -Compress)

        Configure-AppService
        Write-Log "App Service created" -Level 'Success'
    }
    catch {
        Write-Log "Failed to create App Service: $_" -Level 'Error'
        exit 1
    }
}

function Configure-AppService {
    Write-Log "Configuring App Service..."

    try {
        # HTTPS only
        az webapp update `
            --name $config.appServiceName `
            --resource-group $config.resourceGroup `
            --https-only true

        # App settings
        az webapp config appsettings set `
            --name $config.appServiceName `
            --resource-group $config.resourceGroup `
            --settings `
                ASPNETCORE_ENVIRONMENT=$config.aspnetEnvironment `
                ASPNETCORE_URLS="http://+:80" `
                WEBSITE_RUN_FROM_PACKAGE=1

        Write-Log "App Service configured" -Level 'Success'
    }
    catch {
        Write-Log "Failed to configure App Service: $_" -Level 'Error'
        exit 1
    }
}

function Create-SqlServer {
    Write-Log "Creating SQL Server: $($config.sqlServerName)..."

    try {
        $exists = az sql server show `
            --name $config.sqlServerName `
            --resource-group $config.resourceGroup `
            --query id -o tsv 2>$null

        if ($exists) {
            Write-Log "SQL Server already exists" -Level 'Warning'
            return
        }

        if (-not $SqlAdminPassword) {
            $SqlAdminPassword = Read-Host "Enter SQL Server admin password" -AsSecureString
            $SqlAdminPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($SqlAdminPassword))
        }

        az sql server create `
            --name $config.sqlServerName `
            --resource-group $config.resourceGroup `
            --location $config.location `
            --admin-user "sqladmin" `
            --admin-password $SqlAdminPassword `
            --enable-public-network true

        # Allow Azure services
        az sql server firewall-rule create `
            --name "AllowAzureServices" `
            --server $config.sqlServerName `
            --resource-group $config.resourceGroup `
            --start-ip-address 0.0.0.0 `
            --end-ip-address 0.0.0.0

        Write-Log "SQL Server created" -Level 'Success'
    }
    catch {
        Write-Log "Failed to create SQL Server: $_" -Level 'Error'
        exit 1
    }
}

function Create-Database {
    Write-Log "Creating SQL Database: $($config.databaseName)..."

    try {
        $exists = az sql db show `
            --name $config.databaseName `
            --server $config.sqlServerName `
            --resource-group $config.resourceGroup `
            --query id -o tsv 2>$null

        if ($exists) {
            Write-Log "Database already exists" -Level 'Warning'
            return
        }

        az sql db create `
            --name $config.databaseName `
            --server $config.sqlServerName `
            --resource-group $config.resourceGroup `
            --edition $config.sqlSku `
            --capacity $config.sqlCapacity

        Write-Log "Database created" -Level 'Success'
    }
    catch {
        Write-Log "Failed to create database: $_" -Level 'Error'
        exit 1
    }
}

function Configure-ConnectionString {
    Write-Log "Configuring connection string..."

    try {
        $sqlPassword = if ($SqlAdminPassword) { $SqlAdminPassword } else { Read-Host "Enter SQL Server admin password" -AsSecureString }
        if ($sqlPassword -is [SecureString]) {
            $sqlPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($sqlPassword))
        }

        $connectionString = "Server=tcp:$($config.sqlServerName).database.windows.net,1433;Initial Catalog=$($config.databaseName);Persist Security Info=False;User ID=sqladmin;Password=$sqlPassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

        az webapp config connection-string set `
            --name $config.appServiceName `
            --resource-group $config.resourceGroup `
            --settings DefaultConnection=$connectionString `
            --connection-string-type "SQLAzure"

        Write-Log "Connection string configured" -Level 'Success'
    }
    catch {
        Write-Log "Failed to configure connection string: $_" -Level 'Error'
        exit 1
    }
}

function Show-Summary {
    Write-Log "=== SETUP SUMMARY ===" -Level 'Info'
    Write-Log "Environment: $Environment"
    Write-Log "Resource Group: $($config.resourceGroup)"
    Write-Log "Region: $($config.location)"
    Write-Log ""
    Write-Log "App Service:"
    Write-Log "  Name: $($config.appServiceName)"
    Write-Log "  URL: https://$($config.appServiceName).azurewebsites.net"
    Write-Log "  SKU: $($config.appServiceSku)"
    Write-Log ""
    Write-Log "SQL Database:"
    Write-Log "  Server: $($config.sqlServerName).database.windows.net"
    Write-Log "  Database: $($config.databaseName)"
    Write-Log "  Admin: sqladmin"
    Write-Log ""
    Write-Log "Next steps:" -Level 'Success'
    Write-Log "1. Run database migrations: dotnet ef database update"
    Write-Log "2. Deploy application: .\deploy.ps1 -Environment $Environment"
    Write-Log "========================" -Level 'Info'
}

# Main execution
try {
    Write-Log "Starting Azure resource setup for $Environment environment..."

    Test-Prerequisites
    Create-ResourceGroup
    Create-AppServicePlan
    Create-AppService
    Create-SqlServer
    Create-Database
    Configure-ConnectionString

    Show-Summary
}
catch {
    Write-Log "Setup failed: $_" -Level 'Error'
    exit 1
}

Write-Log "Azure resources setup completed successfully!" -Level 'Success'
