# Manual Setup Guide - Angular + .NET Backend

## Complete Configuration & Startup Instructions

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Database Setup](#database-setup)
3. [Angular Frontend Configuration](#angular-frontend-configuration)
4. [NET Backend Configuration](#net-backend-configuration)
5. [Environment Variables](#environment-variables)
6. [Startup Commands](#startup-commands)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software
- **Node.js** 16+ (includes npm)
  - Download: https://nodejs.org/
  - Verify: `node --version` & `npm --version`

- **.NET 10 SDK**
  - Download: https://dotnet.microsoft.com/download/dotnet/10.0
  - Verify: `dotnet --version`

- **SQL Server 2019+ Express**
  - Download: https://www.microsoft.com/sql-server/sql-server-downloads
  - Instance: `localhost\SQLEXPRESS` (default)

- **SQL Server Management Studio (SSMS)** 18+
  - Download: https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms

- **Git** (optional, but recommended)
  - Download: https://git-scm.com/

### Verify Installation
```powershell
# Check versions
node --version          # v18.x.x or higher
npm --version           # 9.x.x or higher
dotnet --version        # 10.0.0 or higher

# Check SQL Server is running
# Windows: Services → SQL Server (SQLEXPRESS)
```

---

## Database Setup

### Step 1: Create Database & Tables

**Using SQL Server Management Studio (SSMS):**

1. **Open SSMS** → Connect to `localhost\SQLEXPRESS`
2. **Execute scripts in order:**
   - Open: `C:\Sai\svags-corporate\backend\database\01_CreateDatabase.sql` → **F5** to execute
   - Open: `C:\Sai\svags-corporate\backend\database\02_CreateTables.sql` → Switch database to `SvagsCorporateDb` → **F5**
   - Open: `C:\Sai\svags-corporate\backend\database\03_InsertSeedData.sql` → Database: `SvagsCorporateDb` → **F5**
   - Open: `C:\Sai\svags-corporate\backend\database\04_VerifyDatabase.sql` → Database: `SvagsCorporateDb` → **F5** (check results)

**Using PowerShell:**

```powershell
# Open PowerShell as Administrator
cd "C:\Sai\svags-corporate\backend\database"

# Execute scripts
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -InputFile "01_CreateDatabase.sql"
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -Database "SvagsCorporateDb" -InputFile "02_CreateTables.sql"
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -Database "SvagsCorporateDb" -InputFile "03_InsertSeedData.sql"
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -Database "SvagsCorporateDb" -InputFile "04_VerifyDatabase.sql"
```

### Step 2: Verify Database Connection

**Connection Details:**
```
Server:   localhost\SQLEXPRESS
Database: SvagsCorporateDb
Auth:     Windows Authentication (Trusted Connection)
```

**Test Connection String (in appsettings.json):**
```
Server=localhost\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;
```

**Expected Tables (17 total):**
- Products
- Technologies
- Solutions
- Industries
- NewsArticles
- CompanyProfiles
- CompanyValues
- Milestones
- CareersInfos
- Benefits
- HiringSteps
- JobPositions
- CareerPrograms
- ContactSubmissions
- NewsletterSubscribers
- JobApplications
- (possibly) AspNetUsers (if authentication tables)

---

## Angular Frontend Configuration

### Project Structure
```
C:\Sai\svags-corporate\
├── src/
│   ├── main.ts                    # Entry point
│   ├── app/
│   │   ├── app.config.ts          # Angular config
│   │   └── app.routes.ts          # Routing
│   ├── environments/
│   │   ├── environment.ts         # Development config
│   │   └── environment.prod.ts    # Production config
│   ├── styles.scss                # Global styles
│   └── assets/
├── angular.json                   # CLI config
├── tailwind.config.js             # Tailwind CSS
└── package.json                   # Dependencies
```

### Configuration Files

#### 1. **environment.ts** (Development)
**Location:** `C:\Sai\svags-corporate\src\environments\environment.ts`

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:5080/api'
};
```

**Key Settings:**
| Setting | Value | Purpose |
|---------|-------|---------|
| `production` | `false` | Enables dev tools & debug mode |
| `apiUrl` | `http://localhost:5080/api` | Points to local .NET backend |

**When to use:** Running `npm start` locally

---

#### 2. **environment.prod.ts** (Production)
**Location:** `C:\Sai\svags-corporate\src\environments\environment.prod.ts`

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://svagstech.com/api'
};
```

**Key Settings:**
| Setting | Value | Purpose |
|---------|-------|---------|
| `production` | `true` | Optimizes bundle, disables debug |
| `apiUrl` | `https://svagstech.com/api` | Production API endpoint |

**Update `apiUrl` for:**
- **Azure Deployment:** `https://svags-corporate-api.azurewebsites.net/api`
- **Custom Domain:** `https://your-domain.com/api`

**When to use:** Building for production (`npm run build`)

---

#### 3. **angular.json** (Build Configuration)
**Location:** `C:\Sai\svags-corporate\angular.json`

**Key Build Settings:**
```json
{
  "projects": {
    "svags-corporate": {
      "projectType": "application",
      "root": "",
      "sourceRoot": "src",
      "prefix": "app",
      "architect": {
        "build": {
          "configurations": {
            "production": {
              "outputHashing": "all",
              "budgets": [
                {
                  "type": "initial",
                  "maximumError": "1MB",
                  "maximumWarning": "500kB"
                }
              ]
            },
            "development": {
              "optimization": false,
              "sourceMap": true
            }
          }
        }
      }
    }
  }
}
```

**Build Targets:**
| Command | Configuration | Output | Purpose |
|---------|---|---|---|
| `npm run build` | production | `dist/` | Optimized build |
| `npm start` | development | dev-server | Local development |

---

#### 4. **tailwind.config.js** (Styling)
**Location:** `C:\Sai\svags-corporate\tailwind.config.js`

Tailwind CSS is configured for utility-first styling. Customize by modifying this file.

---

### Angular Configurations Summary

| File | Environment | API URL | Production Mode | When to Use |
|------|---|---|---|---|
| `environment.ts` | Development | `http://localhost:5080/api` | false | `npm start` |
| `environment.prod.ts` | Production | `https://svagstech.com/api` | true | `npm run build` |

**Important:** Before deploying to Azure or custom domain, **update `apiUrl` in `environment.prod.ts`** to match your backend URL.

---

## .NET Backend Configuration

### Project Structure
```
C:\Sai\svags-corporate\backend\
├── SvagsCorporate.Api/
│   ├── Program.cs                 # App configuration & startup
│   ├── appsettings.json           # Production config
│   ├── appsettings.Development.json # Dev config
│   ├── SvagsCorporate.Api.csproj  # Project file
│   ├── Controllers/               # API endpoints
│   ├── Services/
│   │   └── EmailService.cs        # Email functionality
│   └── Data/
│       ├── AppDbContext.cs        # EF Core context
│       └── Models/                # Entity models
└── database/                      # SQL scripts
    ├── 01_CreateDatabase.sql
    ├── 02_CreateTables.sql
    ├── 03_InsertSeedData.sql
    └── 04_VerifyDatabase.sql
```

### Configuration Files

#### 1. **appsettings.json** (Production)
**Location:** `C:\Sai\svags-corporate\backend\SvagsCorporate.Api\appsettings.json`

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;"
  },
  "Cors": {
    "AllowedOrigins": [
      "https://svagstech.com",
      "https://www.svagstech.com"
    ]
  },
  "Email": {
    "SmtpServer": "",
    "SmtpPort": "587",
    "SmtpUsername": "",
    "SmtpPassword": "",
    "FromEmail": "noreply@svagstech.com",
    "NotificationEmail": "hello@svagstech.com"
  },
  "Storage": {
    "ResumeUploadPath": "./uploads/resumes"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.EntityFrameworkCore": "Information"
    }
  },
  "AllowedHosts": "*"
}
```

---

#### 2. **appsettings.Development.json** (Development)
**Location:** `C:\Sai\svags-corporate\backend\SvagsCorporate.Api\appsettings.Development.json`

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;"
  },
  "Cors": {
    "AllowedOrigins": [
      "http://localhost:4200",
      "http://localhost:5080",
      "http://127.0.0.1:4200"
    ]
  },
  "Email": {
    "SmtpServer": "",
    "SmtpPort": "587",
    "SmtpUsername": "",
    "SmtpPassword": "",
    "FromEmail": "noreply@svagstech.com",
    "NotificationEmail": "hello@svagstech.com"
  },
  "Storage": {
    "ResumeUploadPath": "./uploads/resumes"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Information",
      "Microsoft.AspNetCore": "Information",
      "Microsoft.EntityFrameworkCore": "Information",
      "Microsoft.EntityFrameworkCore.Database.Command": "Information"
    }
  }
}
```

---

### Configuration Sections Explained

#### **ConnectionStrings**
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

| Parameter | Value | Purpose |
|---|---|---|
| `Server` | `localhost\SQLEXPRESS` | SQL Server instance |
| `Database` | `SvagsCorporateDb` | Database name |
| `Trusted_Connection` | `True` | Use Windows Authentication |
| `TrustServerCertificate` | `True` | Accept self-signed cert (dev only) |

**For Azure SQL Database:**
```
Server=tcp:svags-corporate-sql.database.windows.net,1433;Initial Catalog=svags-corporate-db;Persist Security Info=False;User ID=sqladmin;Password=YourPassword123;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;
```

---

#### **CORS Configuration**
```json
"Cors": {
  "AllowedOrigins": [
    "http://localhost:4200",
    "http://localhost:5080",
    "http://127.0.0.1:4200"
  ]
}
```

**Development Allowed Origins:**
- `http://localhost:4200` - Angular dev server (port 4200)
- `http://localhost:5080` - API server (for testing)
- `http://127.0.0.1:4200` - Alternative localhost

**Production Allowed Origins (update for your domain):**
```json
"Cors": {
  "AllowedOrigins": [
    "https://svagstech.com",
    "https://www.svagstech.com"
  ]
}
```

**For Azure:**
```json
"Cors": {
  "AllowedOrigins": [
    "https://svags-corporate-api.azurewebsites.net"
  ]
}
```

---

#### **Email Configuration**
```json
"Email": {
  "SmtpServer": "",
  "SmtpPort": "587",
  "SmtpUsername": "",
  "SmtpPassword": "",
  "FromEmail": "noreply@svagstech.com",
  "NotificationEmail": "hello@svagstech.com"
}
```

**When SMTP is NOT configured:**
- Email sending silently fails with warning log
- No exceptions thrown
- Application continues normally

**To Enable Email (required for forms):**

| SMTP Provider | SmtpServer | SmtpPort | SmtpUsername | SmtpPassword |
|---|---|---|---|---|
| **Gmail** | `smtp.gmail.com` | 587 | your@gmail.com | [App Password](https://myaccount.google.com/apppasswords) |
| **Office 365** | `smtp.office365.com` | 587 | your@company.com | Your password |
| **SendGrid** | `smtp.sendgrid.net` | 587 | `apikey` | Your API key |
| **Mailgun** | `smtp.mailgun.org` | 587 | postmaster@yourdomain | Your API key |

**Example (Gmail):**
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

**Email Features Enabled:**
- Contact form submissions → confirmation to user + notification to admin
- Newsletter signups → welcome email
- Job applications → confirmation to candidate + notification to careers team

---

#### **Storage Configuration**
```json
"Storage": {
  "ResumeUploadPath": "./uploads/resumes"
}
```

| Setting | Value | Purpose |
|---|---|---|
| `ResumeUploadPath` | `./uploads/resumes` | Where to save uploaded resume files |

**Folder will be created at:** `C:\Sai\svags-corporate\backend\SvagsCorporate.Api\uploads\resumes\`

---

#### **Logging Configuration**
```json
"Logging": {
  "LogLevel": {
    "Default": "Information",
    "Microsoft.AspNetCore": "Warning",
    "Microsoft.EntityFrameworkCore": "Information"
  }
}
```

**Log Levels (in order of verbosity):**
1. `Trace` - Most detailed, development only
2. `Debug` - Debug information
3. `Information` - General information (default)
4. `Warning` - Warning messages
5. `Error` - Errors only
6. `Critical` - Critical errors only

**Development Settings:**
```json
"Logging": {
  "LogLevel": {
    "Default": "Information",
    "Microsoft": "Information",
    "Microsoft.AspNetCore": "Information",
    "Microsoft.EntityFrameworkCore": "Information",
    "Microsoft.EntityFrameworkCore.Database.Command": "Information"  // Shows SQL queries
  }
}
```

**Production Settings (less verbose):**
```json
"Logging": {
  "LogLevel": {
    "Default": "Information",
    "Microsoft.AspNetCore": "Warning",
    "Microsoft.EntityFrameworkCore": "Warning"
  }
}
```

---

#### **.NET Project File (SvagsCorporate.Api.csproj)**

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">

  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="MailKit" Version="4.18.0" />
    <PackageReference Include="Microsoft.AspNetCore.OpenApi" Version="10.0.9" />
    <PackageReference Include="Microsoft.OpenApi" Version="2.12.2" />
    <PackageReference Include="Microsoft.EntityFrameworkCore" Version="10.0.0" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="10.0.0" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="10.0.0">
      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
      <PrivateAssets>all</PrivateAssets>
    </PackageReference>
    <PackageReference Include="Swashbuckle.AspNetCore" Version="6.9.0" />
  </ItemGroup>

</Project>
```

**Key Dependencies:**
| Package | Version | Purpose |
|---|---|---|
| `.NET SDK` | 10.0 | Runtime |
| `MailKit` | 4.18.0 | Email sending |
| `EntityFrameworkCore` | 10.0.0 | ORM |
| `EntityFrameworkCore.SqlServer` | 10.0.0 | SQL Server provider |
| `Swashbuckle.AspNetCore` | 6.9.0 | Swagger/OpenAPI |

---

#### **Program.cs** (Startup Configuration)

```csharp
using System.Threading.RateLimiting;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.EntityFrameworkCore;
using SvagsCorporate.Api.Data;
using SvagsCorporate.Api.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddSwaggerGen();

// Rate limiting (5 requests per minute per IP for forms)
builder.Services.AddRateLimiter(options =>
{
    options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
    
    options.AddPolicy("forms", context =>
        RateLimitPartition.GetFixedWindowLimiter(
            context.Connection.RemoteIpAddress?.ToString() ?? "unknown",
            _ => new FixedWindowRateLimiterOptions
            {
                Window = TimeSpan.FromMinutes(1),
                PermitLimit = 5,
                QueueLimit = 0
            }));
});

// Database
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") ??
    "Server=localhost\\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;";

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

// CORS
var allowedOrigins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ??
    new[] { "http://localhost:4200", "http://localhost:5080" };

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowSpecificOrigins", policy =>
    {
        policy.WithOrigins(allowedOrigins)
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

// Services
builder.Services.AddScoped<IEmailService, EmailService>();

// Logging
builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Logging.AddDebug();

var app = builder.Build();

// Pipeline configuration
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseCors("AllowSpecificOrigins");
app.UseRateLimiter();
app.UseAuthorization();
app.MapControllers();

app.Run();
```

**Key Features:**
- ✅ Swagger documentation enabled in Development
- ✅ CORS configured from `appsettings.json`
- ✅ Rate limiting: 5 form submissions per IP per minute
- ✅ Database connection via EF Core
- ✅ Email service registered
- ✅ HTTPS redirection in Production

---

## Environment Variables

### How Environment Variables Work

The .NET application uses **hierarchical configuration**:

1. **appsettings.json** (base)
2. **appsettings.{Environment}.json** (overrides)
3. **Environment Variables** (final override)
4. **User Secrets** (local development only)

**Environment Detection:**
```csharp
var environment = builder.Environment.EnvironmentName;
// "Development" or "Production"
```

---

### Setting Environment Variables (Development)

#### **Method 1: System Environment Variables**

**Windows (GUI):**
1. Press `Win + X` → System
2. Click **Advanced system settings**
3. Click **Environment Variables**
4. Under **User variables**, click **New**
5. Add:
   - `ASPNETCORE_ENVIRONMENT` = `Development`
   - `ConnectionStrings__DefaultConnection` = your connection string

**Requires restart after setting.**

#### **Method 2: Command Line**

**PowerShell:**
```powershell
$env:ASPNETCORE_ENVIRONMENT = "Development"
$env:ASPNETCORE_URLS = "http://+:5080"
$env:Email__SmtpServer = "smtp.gmail.com"
$env:Email__SmtpUsername = "your-email@gmail.com"
$env:Email__SmtpPassword = "your-app-password"
```

**Command Prompt:**
```batch
set ASPNETCORE_ENVIRONMENT=Development
set ASPNETCORE_URLS=http://+:5080
set Email__SmtpServer=smtp.gmail.com
```

#### **Method 3: .env File (Recommended for Development)**

**Create file:** `.env` in `C:\Sai\svags-corporate\backend\SvagsCorporate.Api\`

```env
ASPNETCORE_ENVIRONMENT=Development
ASPNETCORE_URLS=http://+:5080
ConnectionStrings__DefaultConnection=Server=localhost\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;
Email__SmtpServer=smtp.gmail.com
Email__SmtpPort=587
Email__SmtpUsername=your-email@gmail.com
Email__SmtpPassword=your-app-password
Email__FromEmail=noreply@svagstech.com
Email__NotificationEmail=hello@svagstech.com
```

**Note:** Add `.env` to `.gitignore` to avoid committing secrets.

#### **Method 4: launchSettings.json**

**Location:** `C:\Sai\svags-corporate\backend\SvagsCorporate.Api\Properties\launchSettings.json`

```json
{
  "profiles": {
    "http": {
      "commandName": "Project",
      "dotnetRunMessages": true,
      "launchBrowser": true,
      "launchUrl": "swagger",
      "applicationUrl": "http://localhost:5080",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

---

### Required Environment Variables

| Variable | Value (Dev) | Value (Prod) | Purpose |
|---|---|---|---|
| `ASPNETCORE_ENVIRONMENT` | `Development` | `Production` | Enables/disables debug features |
| `ASPNETCORE_URLS` | `http://+:5080` | `http://+:80` | Server URL binding |
| `ConnectionStrings__DefaultConnection` | Local SQL | Azure SQL | Database connection |
| `Email__SmtpServer` | (empty) | smtp.gmail.com | Email server |
| `Email__SmtpPort` | `587` | `587` | SMTP port |
| `Email__SmtpUsername` | (empty) | your@gmail.com | Email username |
| `Email__SmtpPassword` | (empty) | your-app-password | Email password |

---

### Optional Environment Variables

| Variable | Default | When to Use |
|---|---|---|
| `Email__FromEmail` | `noreply@svagstech.com` | Change sender email |
| `Email__NotificationEmail` | `hello@svagstech.com` | Change admin email |
| `Storage__ResumeUploadPath` | `./uploads/resumes` | Change upload location |

---

### Angular Environment Variables

**Angular does NOT use system environment variables directly.**

Instead, configure in:
- `src/environments/environment.ts` (development)
- `src/environments/environment.prod.ts` (production)

**To use dynamic environment URLs in Angular:**

Create `src/assets/config.json`:
```json
{
  "apiUrl": "http://localhost:5080/api",
  "appTitle": "SVAGS Technologies"
}
```

Load in `app.config.ts`:
```typescript
import { HttpClient } from '@angular/common/http';

export async function loadConfig(http: HttpClient) {
  return http.get('/assets/config.json').toPromise();
}
```

---

## Startup Commands

### Angular Frontend

#### **Install Dependencies**
```bash
cd C:\Sai\svags-corporate
npm install
```

**What it does:**
- Downloads all npm packages from `package.json`
- Creates `node_modules/` folder
- Generates `package-lock.json`

**First time: ~2-3 minutes**

---

#### **Development Server (Watch Mode)**
```bash
npm start
```

**Equivalent to:**
```bash
ng serve
```

**Output:**
```
✔ Browser application bundle generation complete.

Initial Chunk Files | Names         | Raw Size | Gzipped Size
main.js             |           ... | 123.4 KB |     32.1 KB

Application bundle generation complete. [65.123 seconds]

Watch mode enabled. Watching for file changes in the Angular CLI project directory.
Local: http://localhost:4200
```

**Access:** Open browser → `http://localhost:4200`

**Features:**
- ✅ Hot module replacement (HMR) - changes auto-reflect
- ✅ SourceMaps enabled for debugging
- ✅ Watches for file changes
- ✅ Press `Ctrl+C` to stop

---

#### **Build for Production**
```bash
npm run build
```

**Equivalent to:**
```bash
ng build --configuration production
```

**Output:**
```
✔ Browser application bundle generation complete.

Generated output directory:
  dist/svags-corporate/browser/
```

**Creates:**
- `dist/svags-corporate/browser/` - Static files
- Optimized & minified JavaScript
- Asset hashing for cache-busting
- Tree-shaken dead code removal

**Size:** ~200-300 KB (gzipped)

**Time:** ~30-60 seconds

---

#### **Build for Development**
```bash
npm run build -- --configuration development
```

**Creates:**
- Non-minified code
- Full SourceMaps
- Useful for debugging

---

#### **Run Tests**
```bash
npm test
```

**Equivalent to:**
```bash
ng test
```

---

#### **Check Bundle Size**
```bash
npm run build -- --stats-json
npm install -g webpack-bundle-analyzer
webpack-bundle-analyzer dist/svags-corporate/browser/stats.json
```

---

### .NET Backend

#### **Install/Restore Dependencies**
```bash
cd C:\Sai\svags-corporate\backend\SvagsCorporate.Api
dotnet restore
```

**What it does:**
- Downloads NuGet packages
- Resolves dependencies

**Time:** ~30-60 seconds

---

#### **Development Server**
```bash
cd C:\Sai\svags-corporate\backend\SvagsCorporate.Api
dotnet run
```

**Output:**
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5080
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to exit.
```

**Access:**
- **API:** `http://localhost:5080/api`
- **Swagger Docs:** `http://localhost:5080/swagger`
- **OpenAPI JSON:** `http://localhost:5080/openapi/v1.json`

**Features:**
- ✅ Hot reload on code changes
- ✅ Detailed error pages in Development
- ✅ Swagger documentation enabled
- ✅ SQL queries logged to console

**Environment:** Automatically uses `Development` mode

---

#### **Build Project**
```bash
dotnet build
```

**Or with Release configuration:**
```bash
dotnet build -c Release
```

**Creates:**
- `bin/Debug/net10.0/` or `bin/Release/net10.0/`
- DLL files and dependencies

---

#### **Publish for Deployment**
```bash
dotnet publish -c Release -o ./publish
```

**Creates:**
- `publish/` folder with all files needed for deployment
- Optimized for production
- Ready for Azure App Service

---

#### **Run in Production Mode**
```bash
$env:ASPNETCORE_ENVIRONMENT = "Production"
dotnet run -c Release
```

---

#### **Run Specific Migrations** (if needed)
```bash
dotnet ef database update
dotnet ef migrations add MigrationName
```

**Note:** This project uses manual SQL scripts, not EF migrations.

---

### Running Both Together

#### **Terminal 1: Start Angular**
```bash
cd C:\Sai\svags-corporate
npm start

# Output: http://localhost:4200
```

#### **Terminal 2: Start .NET Backend**
```bash
cd C:\Sai\svags-corporate\backend\SvagsCorporate.Api
dotnet run

# Output: http://localhost:5080 + Swagger at http://localhost:5080/swagger
```

#### **Terminal 3: Optional - Open Browser**
```powershell
Start-Process "http://localhost:4200"
```

---

## Complete Startup Checklist

### Before First Startup

- [ ] Install Node.js (16+)
- [ ] Install .NET 10 SDK
- [ ] Install SQL Server Express
- [ ] Install SSMS
- [ ] Database created: `SvagsCorporateDb`
- [ ] Database tables created (4 SQL scripts executed)
- [ ] `npm install` in `C:\Sai\svags-corporate`
- [ ] `dotnet restore` in `backend\SvagsCorporate.Api`

### First Time Startup

1. **Terminal 1 - Angular:**
   ```bash
   cd C:\Sai\svags-corporate
   npm install  # Only first time
   npm start
   # Wait for: http://localhost:4200
   ```

2. **Terminal 2 - .NET:**
   ```bash
   cd C:\Sai\svags-corporate\backend\SvagsCorporate.Api
   dotnet restore  # Only first time
   dotnet run
   # Wait for: Now listening on: http://localhost:5080
   ```

3. **Browser:**
   - Angular: `http://localhost:4200`
   - Swagger: `http://localhost:5080/swagger`

### Verification Steps

**Angular Running:**
- Browser shows the website
- No JavaScript errors in console (F12)

**.NET API Running:**
- `http://localhost:5080/api/health` returns 200 OK
- Swagger accessible at `http://localhost:5080/swagger`

**Database Connected:**
- No connection errors in .NET console
- Logs show database queries

---

## Troubleshooting

### Angular Issues

**Error: "npm command not found"**
- Install Node.js from https://nodejs.org/
- Add to PATH or restart PowerShell

**Error: "Port 4200 already in use"**
```bash
# Use different port
ng serve --port 4300
```

**Error: "Cannot find module"**
```bash
# Reinstall dependencies
rm node_modules package-lock.json -r
npm install
```

**Blank page on localhost:4200**
- Check browser console (F12)
- Check if `npm start` is still running
- Try `npm start -- --poll=2000` (for slow file system)

---

### .NET Issues

**Error: "Cannot connect to database"**
1. Verify SQL Server is running: `Services.msc` → SQL Server (SQLEXPRESS)
2. Verify database exists: Open SSMS, check `SvagsCorporateDb`
3. Verify connection string in `appsettings.Development.json`
4. Test connection:
   ```bash
   # In SSMS, test connection with same connection string
   ```

**Error: "Port 5080 already in use"**
1. Change port in `Properties/launchSettings.json`:
   ```json
   "applicationUrl": "http://localhost:5081"
   ```
2. Update Angular's `environment.ts`:
   ```typescript
   apiUrl: 'http://localhost:5081/api'
   ```

**Error: "File access denied (uploads folder)"**
1. Create folder manually:
   ```bash
   mkdir uploads/resumes
   ```
2. Ensure write permissions to folder
3. Run Visual Studio as Administrator

**Error: "CORS error in browser console"**
1. Check `appsettings.Development.json` includes `http://localhost:4200`
2. Add `http://127.0.0.1:4200` if needed
3. Restart .NET backend

**Swagger not loading at http://localhost:5080/swagger**
1. Check `ASPNETCORE_ENVIRONMENT` = `Development`
2. Verify Program.cs includes `app.UseSwaggerUI();`
3. Check browser console for errors

---

### Database Issues

**Error: "Cannot open database 'SvagsCorporateDb'"**
1. Run scripts in SSMS:
   - `01_CreateDatabase.sql`
   - `02_CreateTables.sql`
   - `03_InsertSeedData.sql`
2. Verify database appears in SSMS Object Explorer

**Error: "Login failed for user"**
1. Verify Windows Authentication is enabled
2. Run SSMS as Administrator
3. In Server Properties, enable all login methods

**Tables not created**
1. Open each SQL file in SSMS
2. Ensure database is set to `SvagsCorporateDb`
3. Execute individually (F5)

---

### Email Issues

**Emails not sending (no error)**
- SMTP not configured (expected behavior)
- Check logs for: "Email not sent: SMTP configuration is not set"
- To enable: Configure `Email` section in `appsettings.json`

**Gmail SMTP not working**
1. Enable 2-Factor Authentication
2. Create App Password: https://myaccount.google.com/apppasswords
3. Use app password (not Gmail password)
4. Example:
   ```json
   "Email": {
     "SmtpServer": "smtp.gmail.com",
     "SmtpPort": "587",
     "SmtpUsername": "your-email@gmail.com",
     "SmtpPassword": "xxxx xxxx xxxx xxxx"
   }
   ```

---

## Configuration Reference

### Port Numbers
| Service | Port | URL |
|---|---|---|
| Angular Dev Server | 4200 | http://localhost:4200 |
| .NET Backend | 5080 | http://localhost:5080 |
| SQL Server | 1433 | N/A |
| SSMS | (GUI) | N/A |

### Configuration Files Checklist
- [ ] `C:\Sai\svags-corporate\src\environments\environment.ts` - Angular dev config
- [ ] `C:\Sai\svags-corporate\src\environments\environment.prod.ts` - Angular prod config
- [ ] `C:\Sai\svags-corporate\backend\SvagsCorporate.Api\appsettings.json` - .NET prod config
- [ ] `C:\Sai\svags-corporate\backend\SvagsCorporate.Api\appsettings.Development.json` - .NET dev config

### Useful URLs
- **Angular App:** `http://localhost:4200`
- **API Base:** `http://localhost:5080/api`
- **Swagger UI:** `http://localhost:5080/swagger`
- **OpenAPI JSON:** `http://localhost:5080/openapi/v1.json`

---

**Last Updated:** September 2026
