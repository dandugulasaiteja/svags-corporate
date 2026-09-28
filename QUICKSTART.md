# Quick Start - Azure Deployment

Get your Svags Corporate app to Azure in 5 minutes.

## Prerequisites

```powershell
# Check you have everything
node --version      # Should be 16+
dotnet --version    # Should be 10.0.0+
az --version        # Should be 2.50.0+
git --version       # Should be 2.30+
```

If any are missing, install from: https://aka.ms/azurecli

## Step 1: Login to Azure

```powershell
az login
```

Browser opens → Sign in → Return to terminal

Verify:
```powershell
az account show --query name -o tsv
```

## Step 2: Create Azure Resources (First Time Only)

```powershell
cd C:\Sai\svags-corporate

# For Development
.\setup-azure-resources.ps1 -Environment Dev

# For Production
.\setup-azure-resources.ps1 -Environment Prod
```

This creates:
- ✓ Resource Group
- ✓ App Service (Web App)
- ✓ SQL Database
- ✓ Connection strings

**Takes ~5-10 minutes**

## Step 3: Deploy Your App

```powershell
# For Development
.\deploy.ps1 -Environment Dev

# For Production  
.\deploy.ps1 -Environment Prod -DeployDatabase
```

This builds, packages, and deploys:
- ✓ Angular frontend
- ✓ .NET backend
- ✓ Zips everything
- ✓ Uploads to Azure

**Takes ~3-5 minutes**

## Step 4: Verify Deployment

```powershell
# See your app
https://svags-corporate-api-dev.azurewebsites.net

# View logs
. .\azure-commands.ps1
Get-AppLogs -Environment Dev -Follow
```

---

## Common Tasks

### Redeploy (After code changes)
```powershell
.\deploy.ps1 -Environment Dev
```

### View Logs
```powershell
. .\azure-commands.ps1
Get-AppLogs -Environment Dev -Follow
```

### Restart App
```powershell
. .\azure-commands.ps1
Restart-AppService -Environment Dev
```

### Run Database Migrations
```powershell
# Option 1: During deployment
.\deploy.ps1 -Environment Dev -DeployDatabase

# Option 2: Manually via Kudu
# Go to: https://svags-corporate-api-dev.scm.azurewebsites.net/cmd
# Run: dotnet ef database update
```

### Change App Settings
```powershell
. .\azure-commands.ps1
Set-AppSetting -Environment Dev -Name "ASPNETCORE_ENVIRONMENT" -Value "Production"
```

### View Deployment History
```powershell
. .\azure-commands.ps1
Get-DeploymentHistory -Environment Dev
```

---

## Troubleshooting

### Build fails
```powershell
# Clean and retry
npm cache clean --force
dotnet clean backend/SvagsCorporate.Api
.\deploy.ps1 -Environment Dev
```

### Deployment fails
```powershell
# Check prerequisites
node --version
dotnet --version
az --version

# Login again
az login
```

### App won't start
```powershell
# View logs
. .\azure-commands.ps1
Get-AppLogs -Environment Dev -Follow
```

### Database connection error
```powershell
# Verify connection string
. .\azure-commands.ps1
Get-ConnectionString -Environment Dev

# Check firewall
Get-FirewallRules -Environment Dev
```

---

## Files Created

| File | Purpose |
|------|---------|
| `deploy.ps1` | Main deployment script |
| `setup-azure-resources.ps1` | Create Azure resources |
| `deploy-config.json` | Environment configuration |
| `azure-commands.ps1` | Management utilities |
| `DEPLOYMENT.md` | Full documentation |
| `QUICKSTART.md` | This file |

---

## Next Steps

- [ ] Run `setup-azure-resources.ps1` for your environment
- [ ] Run `deploy.ps1` to deploy the app
- [ ] Test the app: `https://svags-corporate-api-dev.azurewebsites.net`
- [ ] Set up monitoring in Azure Portal
- [ ] Configure custom domain (optional)
- [ ] Review [DEPLOYMENT.md](DEPLOYMENT.md) for advanced topics

---

## Support

For detailed information, see [DEPLOYMENT.md](DEPLOYMENT.md)

For more commands, load utilities:
```powershell
. .\azure-commands.ps1
Show-AzureCommands
```
