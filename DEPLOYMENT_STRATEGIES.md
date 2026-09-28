# Deployment Strategies - Monorepo (Angular + .NET)

## Current Repository Structure

```
svags-corporate/
├── src/                              # Angular frontend source
├── dist/                             # Angular build output
├── angular.json                      # Angular CLI config
├── package.json                      # Angular dependencies
├── tsconfig.json                     # TypeScript config
├── backend/
│   ├── SvagsCorporate.Api/          # .NET backend source
│   │   ├── appsettings.json
│   │   ├── Program.cs
│   │   ├── Controllers/
│   │   ├── Services/
│   │   ├── Data/
│   │   └── SvagsCorporate.Api.csproj
│   ├── database/                    # SQL scripts
│   └── SvagsCorporate.slnx
└── ...
```

**Challenge:** Both projects need to be deployed, but they have different runtimes:
- Angular: Node.js (build-time only) → Static files
- .NET: .NET Runtime (both build & runtime)

---

## Deployment Strategy Options

### **Option 1: Single App Service (Recommended for Monorepo) ⭐**

Deploy everything to **one Azure App Service** running .NET, with Angular served as static files.

**How it works:**
1. Build Angular → `dist/` folder
2. Copy Angular output to .NET `wwwroot/` folder
3. Build .NET backend
4. Deploy entire thing as one package to App Service
5. App Service serves both:
   - Static files (Angular) from `wwwroot/`
   - API endpoints from .NET backend

**Pros:**
- ✅ Single deployment
- ✅ No CORS issues (same origin)
- ✅ Simpler infrastructure
- ✅ Current deployment scripts already do this

**Cons:**
- ❌ Angular build happens on every deployment
- ❌ Can't scale frontend separately
- ❌ Can't update frontend without restarting backend

**Cost:** ~$50-100/month (one App Service + SQL Database)

**Files:**
- Uses current `deploy.ps1` script
- Handles everything automatically

---

### **Option 2: Separate - App Service + Static Web Apps**

Deploy Angular to **Azure Static Web Apps** and .NET backend to **separate App Service**.

**How it works:**
1. Build Angular separately
2. Deploy to Azure Static Web Apps (CDN + static hosting)
3. Build .NET backend
4. Deploy to separate App Service
5. Frontend calls backend via API with CORS headers

**Pros:**
- ✅ Frontend & backend scale independently
- ✅ CDN caching for Angular files (faster)
- ✅ Can deploy frontend without touching backend
- ✅ Frontend served from multiple edge locations
- ✅ Automatic HTTPS for frontend

**Cons:**
- ❌ Two services to manage
- ❌ CORS configuration required
- ❌ Slightly more complex
- ❌ Static Web Apps has limitations (no server-side rendering)

**Cost:** ~$80-150/month (Static Web Apps free tier + App Service + SQL)

**Setup:**
- Requires separate deployment for each
- CI/CD pipelines for both

---

### **Option 3: Docker Containers**

Package both as Docker containers, deploy to **Azure Container Instances** or **Azure App Service (Containers)**.

**How it works:**
1. Create Dockerfile for .NET backend
2. Create Dockerfile for Angular (Node.js build + static server)
3. Push to Azure Container Registry
4. Deploy containers to App Service

**Pros:**
- ✅ Consistent across environments
- ✅ Can scale containers independently
- ✅ Industry standard approach
- ✅ Easier local testing (docker-compose)

**Cons:**
- ❌ Need Docker knowledge
- ❌ More infrastructure complexity
- ❌ Slightly higher cost
- ❌ Not needed for small projects

**Cost:** Similar to Option 2

---

### **Option 4: Monorepo with Separate Builds (GitHub Actions)**

Keep monorepo structure but build & deploy separately with CI/CD.

**How it works:**
1. Detect changes to `src/` → Build & deploy Angular to Static Web Apps
2. Detect changes to `backend/` → Build & deploy .NET to App Service
3. Only rebuild what changed

**Pros:**
- ✅ Intelligent, only deploy what changed
- ✅ Faster deployments
- ✅ Independent deployment pipelines
- ✅ Best for large teams

**Cons:**
- ❌ Complex GitHub Actions setup
- ❌ Requires more maintenance
- ❌ Overkill for small projects

**Cost:** Same as Option 2

---

## Recommended: Option 1 (Single App Service)

### Why?
- ✅ Simplest setup
- ✅ No CORS headaches
- ✅ One billing
- ✅ Current scripts already do this
- ✅ Perfect for small-to-medium projects
- ✅ Can upgrade later if needed

### Architecture

```
Browser
  │
  ├─→ GET / → [App Service]
  │         ├─ Serves index.html (Angular)
  │         ├─ Serves app.js, styles.css (static files)
  │         └─ Serves images, assets
  │
  └─→ POST /api/contact → [App Service]
              └─ .NET Backend processes
```

### Deployment Flow

```
1. npm run build
   └─ Creates: dist/svags-corporate/browser/
      ├─ index.html
      ├─ main.js
      ├─ styles.css
      └─ assets/

2. dotnet publish -c Release
   └─ Creates: backend-publish/
      ├─ SvagsCorporate.Api.dll
      ├─ appsettings.json
      ├─ Program.cs
      └─ ...

3. Copy dist/ → backend-publish/wwwroot/
   └─ backend-publish/
      ├─ wwwroot/               ← Angular files here
      │  ├─ index.html
      │  ├─ main.js
      │  └─ assets/
      └─ SvagsCorporate.Api.dll

4. Create zip of backend-publish/

5. Upload zip to App Service
   └─ App Service extracts & runs
      ├─ Serves static files from wwwroot/
      └─ Handles /api/* requests internally
```

---

## How Current deploy.ps1 Works

The current script uses **Option 1** approach:

```powershell
# Step 1: Build Angular
npm run build
# Result: dist/svags-corporate/browser/

# Step 2: Build .NET
dotnet publish -c Release -o backend-publish/
# Result: backend-publish/

# Step 3: Merge them
Copy-Item dist/* → deploy-package/wwwroot/
Copy-Item backend-publish/* → deploy-package/

# Step 4: Zip
Compress-Archive deploy-package/ → svags-corporate.zip

# Step 5: Deploy
az webapp deployment source config-zip 
  --src svags-corporate.zip
```

**Result:** Single App Service running both

---

## Recommended Deployment Setup

### For Development
```
Terminal 1: npm start
            → Angular on http://localhost:4200

Terminal 2: dotnet run
            → .NET on http://localhost:5080
            
Angular sends requests to: http://localhost:5080/api
```

### For Production (Azure)
```
Single App Service (svags-corporate-api.azurewebsites.net)
  │
  ├─ wwwroot/
  │  ├─ index.html
  │  ├─ main.js (Angular)
  │  └─ assets/
  │
  └─ SvagsCorporate.Api.dll (.NET)
```

Browser request → `https://svags-corporate-api.azurewebsites.net/`
- Serves Angular from wwwroot/
- API calls to `/api/*` handled by .NET

---

## If You Want to Split Later (Option 2)

### 1. Deploy Angular to Static Web Apps

```bash
# Build Angular only
npm run build

# Deploy using GitHub Actions or Azure CLI
az staticwebapp create \
  --name svags-corporate-web \
  --location eastus \
  --source dist/svags-corporate/browser
```

### 2. Deploy .NET to App Service

```bash
# Build .NET only (no Angular in wwwroot)
dotnet publish -c Release -o backend-publish

# Deploy to App Service
az webapp deployment source config-zip \
  --src backend-publish.zip
```

### 3. Update Angular Config

```typescript
// src/environments/environment.prod.ts
export const environment = {
  production: true,
  apiUrl: 'https://svags-corporate-api.azurewebsites.net/api'  // Separate backend URL
};
```

### 4. Add CORS Headers

```json
// backend/SvagsCorporate.Api/appsettings.json
"Cors": {
  "AllowedOrigins": [
    "https://svags-corporate-web.azurestaticapps.net"  // Frontend URL
  ]
}
```

---

## Summary Table

| Aspect | Option 1 | Option 2 | Option 3 | Option 4 |
|--------|----------|----------|----------|----------|
| **Complexity** | ⭐ Simple | ⭐⭐⭐ Medium | ⭐⭐⭐⭐ High | ⭐⭐⭐⭐ High |
| **Cost** | $ | $$ | $$ | $$ |
| **Deployment Time** | ⚡ Fast | ⚡⚡ Faster | ⚡⚡⚡ Slowest | ⚡⚡⚡ Slower |
| **Scaling** | Same | Independent | Independent | Independent |
| **CORS Issues** | None | Needed | None | Needed |
| **Current Scripts** | ✅ Ready | ❌ Needs work | ❌ Needs Docker | ⚠️ Needs CI/CD |
| **Best For** | MVP/Small | Medium/Large | Enterprise | Large Teams |

---

## Immediate Action Plan

### To Deploy Now (Option 1)
```bash
# Use current setup
.\deploy.ps1 -Environment Prod

# Everything deploys as one App Service
```

### To Migrate Later (Option 2)
1. Get Option 1 working first
2. Create Static Web Apps resource
3. Separate deployment scripts
4. Update CORS configuration
5. Update frontend API URL
6. Test & switch

---

## Next Steps

**Current Status:** Ready for Option 1 deployment
- ✅ Scripts handle monorepo correctly
- ✅ Angular builds to dist/
- ✅ .NET builds with Angular in wwwroot/
- ✅ Single zip deployment

**To Deploy:**
1. Run `.\setup-azure-resources.ps1 -Environment Prod`
2. Run `.\deploy.ps1 -Environment Prod`
3. Access at: `https://svags-corporate-api.azurewebsites.net`

**Questions?**
- Want to stick with Option 1? → Continue with deploy.ps1
- Want to split frontend & backend? → I'll create separate deployment scripts
- Want Docker setup? → I'll create Dockerfile + docker-compose

---

**Recommendation:** Use **Option 1** for now, migrate to **Option 2** when you need independent scaling.
