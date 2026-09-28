# Svags Corporate - Azure Deployment Guide

Automated deployment scripts for Angular frontend + .NET backend to Azure.

## Prerequisites

- **Azure Account** with active subscription
- **PowerShell 5.1+**
- **Node.js** (for Angular build)
- **.NET 10 SDK**
- **Azure CLI** (`az` command)
- **Git**

## Installation

### 1. Install Azure CLI

**Windows:**
```powershell
# Using chocolatey
choco install azure-cli

# Or download from: https://aka.ms/azurecli
```

**Verify installation:**
```powershell
az --version
```

### 2. Login to Azure

```powershell
az login
# Browser will open for authentication
```

Verify login:
```powershell
az account show --query name -o tsv
```

### 3. Set Default Subscription (if needed)

```powershell
az account list --query "[].{name:name, id:id}" -o table
az account set --subscription <subscription-id>
```

## Quick Start

### Option A: Full Setup (Recommended for first-time deployment)

#### Step 1: Create Azure Resources
```powershell
cd C:\Sai\svags-corporate
.\setup-azure-resources.ps1 -Environment Dev
```

This will create:
- Resource Group
- App Service (Web App)
- App Service Plan
- SQL Server
- SQL Database
- Connection strings & configuration

#### Step 2: Deploy Application
```powershell
.\deploy.ps1 -Environment Dev
```

This will:
1. Build Angular frontend
2. Build .NET backend
3. Create deployment package
4. Deploy to Azure
5. Clean up temporary files

### Option B: Deploy Only (if resources already exist)
```powershell
.\deploy.ps1 -Environment Dev
```

### Option C: Prepare Package Only (no Azure deployment)
```powershell
.\deploy.ps1 -Environment Dev -OnlyPrepare
```
Creates `svags-corporate-Dev.zip` without deploying.

---

## Usage Examples

### Deploy to Development
```powershell
.\deploy.ps1 -Environment Dev
```

### Deploy to Staging with Database Migration
```powershell
.\deploy.ps1 -Environment Staging -DeployDatabase
```

### Deploy to Production
```powershell
.\deploy.ps1 -Environment Prod
```

### Skip Build (use existing dist/backend-publish)
```powershell
.\deploy.ps1 -Environment Dev -SkipBuild
```

### Prepare Package for Manual Upload
```powershell
.\deploy.ps1 -Environment Dev -OnlyPrepare
```
Then manually upload `svags-corporate-Dev.zip` via Kudu console.

---

## Configuration

### Environments

Three environments are pre-configured in `deploy-config.json`:

| Environment | Resource Group | App Service | Database | SKU |
|---|---|---|---|---|
| **Dev** | `svags-rg-dev` | `svags-corporate-api-dev` | `svags-corporate-db-dev` | B2/S0 |
| **Staging** | `svags-rg-staging` | `svags-corporate-api-staging` | `svags-corporate-db-staging` | S1/S1 |
| **Prod** | `svags-rg` | `svags-corporate-api` | `svags-corporate-db` | P1V2/S2 |

### Customize Configuration

Edit `deploy-config.json`:

```json
{
  "Dev": {
    "resourceGroup": "my-rg",
    "appServiceName": "my-app-api",
    "sqlServerName": "my-sql-server",
    "location": "eastus",  // Change region
    "appServiceSku": "B2",  // Change tier
    ...
  }
}
```

After editing, re-run:
```powershell
.\setup-azure-resources.ps1 -Environment Dev
```

---

## Deployment Scripts

### deploy.ps1 - Main Deployment Script

**Purpose:** Build and deploy application to Azure

**Parameters:**
```powershell
-Environment Dev|Staging|Prod        # Deployment environment (default: Dev)
-SkipBuild                            # Skip build, use existing artifacts
-OnlyPrepare                          # Prepare package without Azure deployment
-DeployDatabase                       # Run database migrations after deploy
```

**Examples:**
```powershell
# Basic deployment
.\deploy.ps1

# Production deployment with database migration
.\deploy.ps1 -Environment Prod -DeployDatabase

# Prepare package only
.\deploy.ps1 -Environment Staging -OnlyPrepare
```

### setup-azure-resources.ps1 - Infrastructure Setup Script

**Purpose:** Create and configure Azure resources

**Parameters:**
```powershell
-Environment Dev|Staging|Prod        # Target environment (default: Dev)
-SqlAdminPassword "password"         # SQL Server admin password (prompted if not provided)
```

**Examples:**
```powershell
# Create Dev resources
.\setup-azure-resources.ps1 -Environment Dev

# Create Prod resources with password
.\setup-azure-resources.ps1 -Environment Prod -SqlAdminPassword "MySecurePass123!"
```

**What it creates:**
- ✓ Resource Group
- ✓ App Service Plan
- ✓ App Service (Windows/.NET)
- ✓ SQL Server
- ✓ SQL Database
- ✓ Connection strings
- ✓ Firewall rules

---

## Deployment Process

### Build Phase
1. Installs npm dependencies
2. Builds Angular application → `dist/`
3. Restores .NET packages
4. Builds .NET backend → `backend-publish/`

### Package Phase
1. Copies Angular `dist/` to `deploy-package/wwwroot/`
2. Copies .NET backend to `deploy-package/`
3. Includes database scripts
4. Creates `svags-corporate-{Env}.zip`

### Deploy Phase
1. Validates Azure resources exist
2. Uploads zip to App Service
3. App Service automatically extracts and runs
4. Optionally runs database migrations

### Cleanup Phase
1. Removes temporary `deploy-package/` folder
2. Removes `backend-publish/` folder
3. Keeps the zip file for rollback

---

## Application Structure After Deployment

```
App Service Root (D:\home\site\wwwroot\)
├── wwwroot/                    # Angular frontend
│   ├── index.html
│   ├── main.js
│   └── assets/
├── SvagsCorporate.Api.dll      # .NET backend
├── appsettings.json
├── web.config
└── database/                   # DB scripts (optional)
```

**Access Points:**
- Frontend: `https://app-name.azurewebsites.net/`
- API: `https://app-name.azurewebsites.net/api/*`
- Swagger: `https://app-name.azurewebsites.net/swagger/index.html`

---

## Troubleshooting

### Build Issues

**Node.js/npm errors:**
```powershell
node --version    # Should be 16+
npm --version     # Should be 8+
npm cache clean --force
npm install
```

**.NET errors:**
```powershell
dotnet --version  # Should be 10.0.0+
dotnet clean backend/SvagsCorporate.Api
dotnet restore backend/SvagsCorporate.Api
```

### Deployment Issues

**Azure CLI not found:**
```powershell
# Reinstall Azure CLI
choco uninstall azure-cli
choco install azure-cli
```

**Not logged in to Azure:**
```powershell
az login
az account show
```

**Resource group doesn't exist:**
```powershell
az group create --name svags-rg-dev --location eastus
```

**App Service doesn't exist:**
```powershell
# Run setup script first
.\setup-azure-resources.ps1 -Environment Dev
```

### Runtime Issues

**Check deployment logs:**
```powershell
# View last 100 lines
az webapp log tail --resource-group svags-rg-dev --name svags-corporate-api-dev --lines 100

# Follow live logs
az webapp log tail --resource-group svags-rg-dev --name svags-corporate-api-dev -f
```

**Restart app:**
```powershell
az webapp restart --resource-group svags-rg-dev --name svags-corporate-api-dev
```

**Check database connection:**
```powershell
# View application settings
az webapp config appsettings list --resource-group svags-rg-dev --name svags-corporate-api-dev

# View connection strings
az webapp config connection-string list --resource-group svags-rg-dev --name svags-corporate-api-dev
```

### Database Issues

**Run migrations via Kudu Console:**
1. Go to `https://svags-corporate-api-dev.scm.azurewebsites.net/cmd`
2. Navigate to `D:\home\site\wwwroot`
3. Run: `dotnet ef database update`

**Execute SQL scripts:**
1. Connect via Azure SQL Server Management Studio
2. Run scripts from `database/` folder

---

## Rollback

### Rollback to Previous Deployment

```powershell
# View deployment history
az webapp deployment list --resource-group svags-rg-dev --name svags-corporate-api-dev --query "[0:5]" --output table

# Activate specific deployment
az webapp deployment slot swap --name svags-corporate-api-dev --resource-group svags-rg-dev --slot staging

# Or manually upload previous zip
az webapp deployment source config-zip --resource-group svags-rg-dev --name svags-corporate-api-dev --src svags-corporate-backup.zip
```

---

## Monitoring & Logging

### Enable Application Insights

```powershell
# Create Application Insights
az monitor app-insights component create \
  --app svags-insights-dev \
  --location eastus \
  --resource-group svags-rg-dev \
  --application-type web

# Link to App Service
az webapp config appsettings set \
  --name svags-corporate-api-dev \
  --resource-group svags-rg-dev \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY=<key>
```

### View Live Logs

```powershell
# SSH into App Service
az webapp create-remote-connection --name svags-corporate-api-dev --resource-group svags-rg-dev

# Or use Log Stream
az webapp log tail --resource-group svags-rg-dev --name svags-corporate-api-dev -f
```

---

## Production Checklist

Before deploying to Production:

- [ ] Test in Dev and Staging environments
- [ ] Review connection strings and credentials
- [ ] Enable HTTPS only
- [ ] Configure custom domain
- [ ] Enable Application Insights
- [ ] Set up backup and restore
- [ ] Configure alerts
- [ ] Review CORS settings
- [ ] Validate database backups
- [ ] Test rollback procedure
- [ ] Document runbooks
- [ ] Set up monitoring dashboards

---

## Common Commands

```powershell
# List all resources in resource group
az resource list --resource-group svags-rg-dev --output table

# View App Service details
az webapp show --name svags-corporate-api-dev --resource-group svags-rg-dev

# View current deployment slots
az webapp deployment slot list --name svags-corporate-api-dev --resource-group svags-rg-dev

# Create deployment slot
az webapp deployment slot create --name svags-corporate-api-dev --resource-group svags-rg-dev --slot staging

# Swap slots
az webapp deployment slot swap --name svags-corporate-api-dev --resource-group svags-rg-dev --slot staging

# Delete resource group (careful!)
az group delete --name svags-rg-dev --yes --no-wait
```

---

## Support

For issues:

1. **Check logs:** `az webapp log tail --resource-group [rg] --name [app] -f`
2. **Verify prerequisites:** Run `node --version`, `dotnet --version`, `az --version`
3. **Review configuration:** Check `deploy-config.json`
4. **Azure Portal:** Monitor App Service health and logs
5. **Kudu Console:** Debug at `https://[app].scm.azurewebsites.net/cmd`

---

## Environment Variables

These are automatically set by deployment scripts:

- `ASPNETCORE_ENVIRONMENT` - Development/Staging/Production
- `ASPNETCORE_URLS` - http://+:80
- `WEBSITE_RUN_FROM_PACKAGE` - 1 (zip deployment mode)
- `DefaultConnection` - SQL Server connection string

Additional variables can be added in `deploy.ps1` under the "Configure App Settings" section.

---

**Last Updated:** September 2026
