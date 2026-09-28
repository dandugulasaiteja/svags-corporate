# Step-by-Step Azure Portal Setup Guide

## 🎯 Goal
Set up App Service + SQL Database + Deploy your Angular + .NET application

---

## STEP 1: Create Resource Group

**What is it?** Container for all your Azure resources

### Instructions:

1. Go to **Azure Portal** → https://portal.azure.com
2. Click **Resource groups** (or search for it)
3. Click **+ Create**

**Fill in:**
```
Resource group name:  svags-rg-prod
Region:               East US (or your preferred region)
```

4. Click **Review + Create**
5. Click **Create**

**Wait for:** ✅ "Deployment succeeded"

---

## STEP 2: Create SQL Server

**What is it?** Your database server

### Instructions:

1. Click **+ Create a resource** (top-left)
2. Search for: **SQL Server**
3. Click **SQL Server** → Click **Create**

**Fill in:**

| Field | Value |
|-------|-------|
| Subscription | Your subscription |
| Resource group | **svags-rg-prod** (select the one we created) |
| Server name | **svags-corporate-sql-prod** |
| Location | **East US** (same as resource group) |
| Authentication | **Use SQL authentication** |
| Server admin login | **sqladmin** |
| Password | Create a strong password (save this!) |
| Confirm password | Same password |

**Example password:** `Sv@gsDb#2024Prod!`

4. Click **Next: Networking** (don't change anything)
5. Click **Review + Create**
6. Click **Create**

**Wait for:** ✅ "Your deployment is complete"

---

## STEP 3: Create SQL Database

**What is it?** Your actual database

### Instructions:

1. Go to the **SQL Server** we just created
   - Click on: **svags-corporate-sql-prod**

2. In the left menu, click **Databases**

3. Click **+ Create database**

**Fill in:**

| Field | Value |
|-------|-------|
| Database name | **SvagsCorporateDb** |
| Compute + storage | **Standard S0** (cheapest option, click to configure) |

4. Click **Review + Create**
5. Click **Create**

**Wait for:** ✅ Database appears in the list

---

## STEP 4: Configure SQL Server Firewall

**What is it?** Allow Azure services and your IP to connect

### Instructions:

1. Go to **SQL Server** → **svags-corporate-sql-prod**
2. In left menu, click **Networking**
3. Click **+ Add your client IP address**
4. Click **Allow Azure services and resources to access this server** toggle → **ON**
5. Click **Save**

**Wait for:** ✅ "Successfully updated server firewall rules"

---

## STEP 5: Create App Service Plan

**What is it?** The server tier for your web app

### Instructions:

1. Click **+ Create a resource**
2. Search for: **App Service Plan**
3. Click **App Service Plan** → Click **Create**

**Fill in:**

| Field | Value |
|-------|-------|
| Subscription | Your subscription |
| Resource group | **svags-rg-prod** |
| Name | **svags-plan-prod** |
| Operating System | **Windows** |
| Region | **East US** |
| Sku and size | Click **Change size** → Select **B2** → Click **Apply** |

**B2 Details:**
- 2 vCPU
- 3.5 GB RAM
- ~$50/month
- Good for production

4. Click **Review + Create**
5. Click **Create**

**Wait for:** ✅ "Deployment succeeded"

---

## STEP 6: Create App Service

**What is it?** Your web application host (runs .NET + Angular)

### Instructions:

1. Click **+ Create a resource**
2. Search for: **App Service**
3. Click **App Service** → Click **Create**

**Fill in:**

| Field | Value |
|-------|-------|
| Subscription | Your subscription |
| Resource group | **svags-rg-prod** |
| Name | **svags-corporate-api-prod** |
| Publish | **Code** |
| Runtime stack | **.NET 10 (LTS)** |
| Operating System | **Windows** |
| Region | **East US** |
| App Service Plan | Click → Select **svags-plan-prod** |

4. Click **Review + Create**
5. Click **Create**

**Wait for:** ✅ "Deployment succeeded"

⏱️ **This takes 2-3 minutes**

---

## STEP 7: Configure App Service Settings

### Part A: Add Connection String

1. Go to **App Service** → **svags-corporate-api-prod**
2. In left menu, click **Configuration**
3. Click **+ New connection string**

**Fill in:**

| Field | Value |
|-------|-------|
| Name | **DefaultConnection** |
| Value | Paste below ↓ |
| Type | **SQL Server** |

**Connection String Value:**
```
Server=tcp:svags-corporate-sql-prod.database.windows.net,1433;Initial Catalog=SvagsCorporateDb;Persist Security Info=False;User ID=sqladmin;Password=YOUR_PASSWORD;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;
```

Replace `YOUR_PASSWORD` with the password you created for SQL Server!

4. Click **OK**
5. Click **Save** (top)

**Wait for:** ✅ "Updated application settings"

---

### Part B: Add Application Settings

1. Still in **Configuration**
2. Click **+ New application setting** (repeat for each)

**Add these one by one:**

**Setting 1:**
```
Name:  ASPNETCORE_ENVIRONMENT
Value: Production
```

**Setting 2:**
```
Name:  ASPNETCORE_URLS
Value: http://+:80
```

**Setting 3:**
```
Name:  WEBSITE_RUN_FROM_PACKAGE
Value: 1
```

**Setting 4 (Optional - for email):**
```
Name:  Email__SmtpServer
Value: smtp.gmail.com
```

**Setting 5 (Optional - for email):**
```
Name:  Email__SmtpPort
Value: 587
```

After each one:
- Click **OK**
- Then click **Save** (top)

**Wait for:** ✅ "Updated application settings"

---

### Part C: Enable HTTPS Only

1. In **Configuration**, scroll down
2. Find **General settings**
3. Toggle **HTTPS Only** → **ON**
4. **Minimum TLS version** → **1.2**
5. Click **Save**

---

## STEP 8: Set Up Database

### Part A: Run SQL Scripts

Now we need to create tables in your Azure SQL Database.

**Option 1: Using Azure Query Editor (Easy)**

1. Go to **SQL Database** → **SvagsCorporateDb**
2. Click **Query editor**
3. Login with:
   - Username: **sqladmin**
   - Password: (your password)

4. Copy-paste content from: `backend/database/01_CreateDatabase.sql`
5. Click **Run**
6. Repeat for: `02_CreateTables.sql`, `03_InsertSeedData.sql`

**Option 2: Using SQL Server Management Studio (SSMS)**

1. Open **SSMS** on your computer
2. Connect to:
   ```
   Server: svags-corporate-sql-prod.database.windows.net
   User: sqladmin
   Password: (your password)
   ```
3. Open files from `backend/database/` and execute

---

### Part B: Verify Database

1. Go to **SQL Database** → **SvagsCorporateDb**
2. Click **Query editor**
3. Run this query:
```sql
SELECT COUNT(*) as TableCount 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo'
```

**Expected result:** 17 (or similar number of tables)

✅ If you see tables, database is ready!

---

## STEP 9: Deploy Your Application

### Part A: Build Your Code Locally

**Open PowerShell on your computer:**

```powershell
cd C:\Sai\svags-corporate

# Update Angular config for production
# Edit: src/environments/environment.prod.ts
# Change apiUrl to: https://svags-corporate-api-prod.azurewebsites.net/api
```

**In PowerShell, run deployment script:**

```powershell
.\deploy.ps1 -Environment Prod
```

**What it does:**
1. ✅ Installs npm packages
2. ✅ Builds Angular (creates dist/)
3. ✅ Restores .NET packages
4. ✅ Builds .NET (creates backend-publish/)
5. ✅ Merges Angular into .NET wwwroot/
6. ✅ Creates zip file
7. ✅ Uploads to Azure App Service
8. ✅ App Service extracts and starts

**Wait for:** ✅ "Deployment to Azure completed"

⏱️ **This takes 5-10 minutes**

---

### Part B: Alternative - Manual Deployment (If Script Fails)

**If deploy.ps1 doesn't work:**

```powershell
# Step 1: Build manually
cd C:\Sai\svags-corporate
npm install
npm run build
cd backend\SvagsCorporate.Api
dotnet restore
dotnet publish -c Release -o ../../backend-publish

# Step 2: Go back to root
cd C:\Sai\svags-corporate

# Step 3: Merge
$dest = "deploy-package"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
New-Item -ItemType Directory -Path "$dest/wwwroot" -Force | Out-Null

Copy-Item -Path "dist/*" -Destination "$dest/wwwroot" -Recurse -Force
Copy-Item -Path "backend-publish/*" -Destination "$dest" -Recurse -Force -Exclude "wwwroot"

# Step 4: Zip
Compress-Archive -Path "$dest/*" -DestinationPath "svags-corporate-prod.zip" -Force

# Step 5: Deploy
az webapp deployment source config-zip `
  --resource-group svags-rg-prod `
  --name svags-corporate-api-prod `
  --src svags-corporate-prod.zip
```

---

## STEP 10: Verify Deployment

### Check 1: App Service Status

1. Go to **App Service** → **svags-corporate-api-prod**
2. Look at the URL: `https://svags-corporate-api-prod.azurewebsites.net`
3. Check **Status** should be **Running**

### Check 2: View Logs

1. Click **Log stream** (left menu)
2. You should see application logs
3. Look for errors or successful startup messages

### Check 3: Test in Browser

**Open new tab and go to:**
```
https://svags-corporate-api-prod.azurewebsites.net
```

**You should see:**
- ✅ SVAGS Technologies website (Angular frontend)
- ✅ Navigation working
- ✅ No 404 errors

**Test API:**
```
https://svags-corporate-api-prod.azurewebsites.net/swagger
```

**You should see:**
- ✅ Swagger documentation
- ✅ API endpoints listed

**Test Database Connection:**
```
https://svags-corporate-api-prod.azurewebsites.net/api/products
```

**You should see:**
- ✅ JSON response with products
- ✅ No connection errors

---

## STEP 11: Configure Custom Domain (Optional)

**If you have a domain (svagstech.com):**

1. Go to **App Service** → **svags-corporate-api-prod**
2. Click **Custom domains** (left menu)
3. Click **+ Add custom domain**
4. Enter your domain: **svagstech.com**
5. Follow DNS configuration steps
6. Azure provides you with DNS records to add to your registrar

---

## STEP 12: Enable HTTPS with SSL Certificate (Optional)

**Azure automatically provides HTTPS!**

1. Your app is already accessible at:
   ```
   https://svags-corporate-api-prod.azurewebsites.net
   ```

2. Azure manages the SSL certificate automatically

3. If using custom domain, click **TLS/SSL settings**
4. Upload your certificate or let Azure manage it

---

## ✅ Verification Checklist

- [ ] Resource Group created
- [ ] SQL Server created with firewall rules
- [ ] SQL Database created
- [ ] App Service Plan created
- [ ] App Service created and running
- [ ] Connection string configured
- [ ] Application settings configured
- [ ] Database tables created (17 tables)
- [ ] Application deployed via zip
- [ ] Website accessible at `https://svags-corporate-api-prod.azurewebsites.net`
- [ ] Swagger docs accessible at `/swagger`
- [ ] API endpoints returning data
- [ ] No errors in App Service logs

---

## 🆘 Troubleshooting

### App Service Shows Error

**Check logs:**
1. Go to **App Service** → **Log stream**
2. Look for red error messages
3. Most common: Connection string issue

**Fix connection string:**
1. Go to **Configuration**
2. Find **DefaultConnection**
3. Verify password matches SQL Server admin password
4. Click **Save**

### Database Connection Failed

**Test connection:**
1. Open **SQL Database** → **Query editor**
2. Try running a simple query:
   ```sql
   SELECT 1
   ```
3. If it works, database is fine

**Check App Service config:**
1. Verify connection string in **Configuration**
2. Verify SQL Server firewall allows App Service
3. Restart App Service (click **Restart** button)

### Website Shows 404

**Likely causes:**
1. Angular not deployed (check if dist/ is in deployment)
2. App Service not running (check status)
3. Still deploying (wait 2-3 minutes)

**Fix:**
1. Check **Log stream** for errors
2. Re-run deployment script
3. Restart App Service

### Swagger Not Loading

**Likely cause:** Running in Production mode

**Fix:**
1. This is expected in production
2. Swagger disabled for security
3. Use Postman or curl to test API instead

---

## Cost Breakdown

| Service | Tier | Cost/Month |
|---------|------|-----------|
| **App Service** | B2 | ~$50 |
| **SQL Database** | Standard S0 | ~$15 |
| **Total** | - | ~**$65/month** |

**Can reduce to:**
- B1 tier: ~$25/month (less powerful)
- Free tier for testing: $0

---

## Common Tasks After Deployment

### Update Website Code

```powershell
# Make changes to src/
cd C:\Sai\svags-corporate
npm run build
dotnet publish -c Release -o backend-publish
# ... merge and zip ...
az webapp deployment source config-zip ...
```

### View Application Logs

1. App Service → **Log stream**
2. Or **Application Insights** for detailed monitoring

### Restart App Service

1. App Service → Click **Restart** button
2. Takes ~30 seconds

### Scale Up (More Power)

1. App Service → **Scale up** (left menu)
2. Choose larger tier
3. Click **Apply**

### Backup Database

1. SQL Database → **Backups** (left menu)
2. Azure automatically backs up

---

## Next Steps

1. ✅ Verify everything is working
2. ✅ Test all features on live site
3. ✅ Set up monitoring (Application Insights)
4. ✅ Configure domain name (optional)
5. ✅ Set up email notifications

---

## URLs

| Item | URL |
|------|-----|
| **Your Website** | `https://svags-corporate-api-prod.azurewebsites.net` |
| **Swagger API Docs** | `https://svags-corporate-api-prod.azurewebsites.net/swagger` |
| **Azure Portal** | `https://portal.azure.com` |
| **App Service** | Search "svags-corporate-api-prod" in portal |
| **SQL Database** | Search "SvagsCorporateDb" in portal |

---

**Estimated Time:** 30-45 minutes total

**Any issues? Check the logs in App Service → Log stream**

