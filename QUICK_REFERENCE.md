# Quick Reference Card

## 🚀 QUICK START (3 STEPS)

### Step 1: Database Setup
```sql
-- Open SQL Server Management Studio (SSMS)
-- Connect to: localhost\SQLEXPRESS
-- Execute these scripts in order:
1. backend\database\01_CreateDatabase.sql
2. backend\database\02_CreateTables.sql (switch to SvagsCorporateDb first!)
3. backend\database\03_InsertSeedData.sql
4. backend\database\04_VerifyDatabase.sql (verification only)
```

### Step 2: Start Angular Frontend
```bash
cd C:\Sai\svags-corporate
npm install          # First time only
npm start

# Open: http://localhost:4200
```

### Step 3: Start .NET Backend
```bash
cd C:\Sai\svags-corporate\backend\SvagsCorporate.Api
dotnet restore       # First time only
dotnet run

# API: http://localhost:5080/api
# Swagger: http://localhost:5080/swagger
```

---

## 📁 KEY FILES & PATHS

### Angular Configuration
| File | Path | Purpose |
|------|------|---------|
| Dev Config | `src/environments/environment.ts` | Development settings |
| Prod Config | `src/environments/environment.prod.ts` | Production API URL |
| Build Config | `angular.json` | Build configuration |

### .NET Configuration
| File | Path | Purpose |
|------|------|---------|
| Dev Config | `backend/SvagsCorporate.Api/appsettings.Development.json` | Dev settings |
| Prod Config | `backend/SvagsCorporate.Api/appsettings.json` | Production settings |
| Startup | `backend/SvagsCorporate.Api/Program.cs` | App initialization |

### Database Scripts
| Script | Purpose |
|--------|---------|
| `01_CreateDatabase.sql` | Create database |
| `02_CreateTables.sql` | Create schema |
| `03_InsertSeedData.sql` | Load sample data |
| `04_VerifyDatabase.sql` | Verify setup |

---

## 🔧 CONFIGURATION VALUES

### Angular Environment Settings

**Development** (`src/environments/environment.ts`):
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:5080/api'
};
```

**Production** (`src/environments/environment.prod.ts`):
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://svagstech.com/api'  // Change for deployment
};
```

---

### .NET Connection String

**Default** (in `appsettings.json`):
```
Server=localhost\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;
```

**For Azure SQL:**
```
Server=tcp:svags-corporate-sql.database.windows.net,1433;Initial Catalog=svags-corporate-db;User ID=sqladmin;Password=YourPassword;Encrypt=True;
```

---

### .NET CORS Configuration

**Development** (`appsettings.Development.json`):
```json
"Cors": {
  "AllowedOrigins": [
    "http://localhost:4200",
    "http://localhost:5080"
  ]
}
```

**Production** (`appsettings.json`):
```json
"Cors": {
  "AllowedOrigins": [
    "https://svagstech.com",
    "https://www.svagstech.com"
  ]
}
```

---

### .NET Email Configuration

**To Enable Emails** (update `appsettings.json` or env vars):
```json
"Email": {
  "SmtpServer": "smtp.gmail.com",
  "SmtpPort": "587",
  "SmtpUsername": "your-email@gmail.com",
  "SmtpPassword": "your-app-password",
  "FromEmail": "noreply@svagstech.com",
  "NotificationEmail": "hello@svagstech.com"
}
```

**Supported SMTP Providers:**
- Gmail: `smtp.gmail.com:587` (use app password)
- Office 365: `smtp.office365.com:587`
- SendGrid: `smtp.sendgrid.net:587`
- Mailgun: `smtp.mailgun.org:587`

---

## 📊 PORT NUMBERS

| Service | Port | URL |
|---------|------|-----|
| Angular | 4200 | `http://localhost:4200` |
| .NET API | 5080 | `http://localhost:5080` |
| SQL Server | 1433 | N/A |

---

## 🎯 STARTUP COMMANDS

### Angular
```bash
npm install          # Install dependencies (first time)
npm start            # Start dev server
npm run build        # Build for production
npm test             # Run tests
```

### .NET
```bash
dotnet restore       # Restore packages (first time)
dotnet run           # Start dev server
dotnet build         # Build project
dotnet publish -c Release -o ./publish  # Build for deployment
```

### Database
```sql
-- SSMS: Open file and press F5
-- Or PowerShell:
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -InputFile "script.sql"
```

---

## 🌍 API ENDPOINTS

**Base URL:** `http://localhost:5080/api/`

**Key Endpoints:**
- `GET /api/health` - Health check
- `GET /api/products` - All products
- `GET /api/technologies` - All technologies
- `GET /api/solutions` - All solutions
- `GET /api/industries` - All industries
- `GET /api/jobs` - All job positions
- `POST /api/contact` - Submit contact form
- `POST /api/newsletter` - Subscribe to newsletter
- `POST /api/applications` - Submit job application

**Swagger Documentation:**
- URL: `http://localhost:5080/swagger`
- OpenAPI JSON: `http://localhost:5080/openapi/v1.json`

---

## 🔐 ENVIRONMENT VARIABLES

### Required (Development)
```
ASPNETCORE_ENVIRONMENT=Development
ASPNETCORE_URLS=http://+:5080
ConnectionStrings__DefaultConnection=Server=localhost\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;
```

### Optional (Email)
```
Email__SmtpServer=smtp.gmail.com
Email__SmtpPort=587
Email__SmtpUsername=your-email@gmail.com
Email__SmtpPassword=your-app-password
Email__FromEmail=noreply@svagstech.com
Email__NotificationEmail=hello@svagstech.com
```

**To Set (PowerShell):**
```powershell
$env:ASPNETCORE_ENVIRONMENT = "Development"
$env:Email__SmtpServer = "smtp.gmail.com"
```

---

## 📦 DEPENDENCIES

### Angular
- **Node.js:** 16+
- **npm:** 8+
- **Angular:** 21.2.0
- **Tailwind CSS:** 4.3.3

### .NET
- **.NET SDK:** 10.0
- **Entity Framework Core:** 10.0.0
- **MailKit:** 4.18.0
- **Swashbuckle:** 6.9.0

### Database
- **SQL Server:** 2019+ (Express)
- **SSMS:** 18+

---

## 🐛 COMMON ISSUES

### Angular Won't Start
```bash
# Clean install
rm node_modules package-lock.json -r
npm install
npm start
```

### Port Already in Use
```bash
# Use different port
ng serve --port 4300

# Update environment.ts accordingly
```

### Database Connection Failed
```sql
-- Verify in SSMS
-- Check: Database exists, tables created, authentication works
-- Test connection string
```

### CORS Error in Browser
```json
// Add to appsettings.Development.json:
"Cors": {
  "AllowedOrigins": [
    "http://localhost:4200"
  ]
}
```

### Email Not Sending
- Check if SMTP configured in `appsettings.json`
- Check logs for: "SMTP configuration is not set"
- Verify Gmail/Office365 credentials if enabled

---

## 🔄 WORKFLOW

### Make Changes
1. Edit code (Angular in `src/`, .NET in `backend/`)
2. Save file
3. Browser/app auto-reloads (hot reload enabled)

### Deploy to Azure
1. Build: `npm run build`
2. Use automated script: `.\deploy.ps1 -Environment Prod`
3. Or manually zip and upload to App Service

### Update Database Schema
1. Create new SQL script in `backend/database/`
2. Execute via SSMS or `Invoke-Sqlcmd`
3. Update any related models/controllers

---

## 📚 DETAILED DOCUMENTATION

For complete details, see **MANUAL_SETUP.md**:
- Full configuration explanations
- Troubleshooting guide
- Security settings
- Production deployment

---

## ✅ VERIFICATION CHECKLIST

- [ ] SQL Server running (Services.msc)
- [ ] Database `SvagsCorporateDb` created
- [ ] All 4 SQL scripts executed
- [ ] Node.js installed (node --version)
- [ ] .NET SDK installed (dotnet --version)
- [ ] npm install completed
- [ ] dotnet restore completed
- [ ] Angular starts: npm start → http://localhost:4200
- [ ] .NET starts: dotnet run → http://localhost:5080/swagger
- [ ] Can see Angular UI in browser
- [ ] Can access Swagger docs
- [ ] No console errors

---

## 🆘 NEED HELP?

1. Check **MANUAL_SETUP.md** for detailed explanations
2. Review console output for specific error messages
3. Check browser console (F12) for JavaScript errors
4. Verify configuration files match examples above
5. Ensure SQL Server and all services are running

---

**Last Updated:** September 2026
