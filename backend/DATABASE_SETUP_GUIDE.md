# SVAGS Technologies - Complete Database Setup Guide

## 📁 Database Scripts Location

All database scripts are located in: `C:\Sai\svags-corporate\backend\database\`

## 📋 Scripts Overview

| Script | Purpose | Execute | Notes |
|--------|---------|---------|-------|
| `00_DropDatabase.sql` | Reset/cleanup | Only if needed | ⚠️ Deletes all data |
| `01_CreateDatabase.sql` | Create database | 1st | Creates `SvagsCorporateDb` |
| `02_CreateTables.sql` | Create schema | 2nd | 17 tables with relationships |
| `03_InsertSeedData.sql` | Load initial data | 3rd | Products, techs, jobs, etc. |
| `04_VerifyDatabase.sql` | Verify setup | After 03 | Checks if everything is correct |
| `README.md` | Documentation | Reference | Detailed info |

## ⚙️ Prerequisites

- SQL Server 2019+ (Developer/Express Edition)
- SQL Server Management Studio (SSMS) 18+
- TCP/IP enabled in SQL Server Configuration Manager
- Default instance: `localhost\SQLEXPRESS`

## 🚀 Quick Start (3 Steps)

### Step 1: Open SQL Server Management Studio (SSMS)

1. Launch **SQL Server Management Studio**
2. Connect to: `localhost\SQLEXPRESS` (or your SQL Server instance)
3. Click **Connect**

### Step 2: Execute Database Creation

1. Go to **File → Open → Open File** (or Ctrl+O)
2. Navigate to: `C:\Sai\svags-corporate\backend\database\`
3. Select: `01_CreateDatabase.sql`
4. Click **Open**
5. Click **Execute** button (or press F5)
6. Wait for completion (you'll see "Database [SvagsCorporateDb] created successfully!")

### Step 3: Execute Table Creation

1. Go to **File → Open → Open File**
2. Select: `02_CreateTables.sql`
3. Click **Open**
4. **IMPORTANT**: Ensure you've switched to `SvagsCorporateDb`
   - In the query window top-left, change dropdown from "master" to "SvagsCorporateDb"
5. Click **Execute** (F5)
6. Wait for completion

### Step 4: Insert Seed Data

1. Go to **File → Open → Open File**
2. Select: `03_InsertSeedData.sql`
3. Click **Open**
4. Ensure database is still set to `SvagsCorporateDb`
5. Click **Execute** (F5)
6. Wait for completion

### Step 5: Verify Installation

1. Go to **File → Open → Open File**
2. Select: `04_VerifyDatabase.sql`
3. Click **Open**
4. Click **Execute** (F5)
5. You should see a report with table counts and sample data

## 🖥️ Alternative: Command Line Setup

If you prefer command line, use **PowerShell**:

```powershell
# Open PowerShell as Administrator
# Navigate to database folder
cd "C:\Sai\svags-corporate\backend\database"

# Execute all scripts in sequence
Write-Host "Creating database..." -ForegroundColor Green
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -InputFile "01_CreateDatabase.sql"

Write-Host "Creating tables..." -ForegroundColor Green
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -Database "SvagsCorporateDb" -InputFile "02_CreateTables.sql"

Write-Host "Inserting seed data..." -ForegroundColor Green
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -Database "SvagsCorporateDb" -InputFile "03_InsertSeedData.sql"

Write-Host "Verifying installation..." -ForegroundColor Green
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -Database "SvagsCorporateDb" -InputFile "04_VerifyDatabase.sql"

Write-Host "Setup complete!" -ForegroundColor Cyan
```

Or use **Command Prompt (sqlcmd)**:

```batch
@echo off
cd "C:\Sai\svags-corporate\backend\database"

echo Creating database...
sqlcmd -S localhost\SQLEXPRESS -E -i 01_CreateDatabase.sql

echo Creating tables...
sqlcmd -S localhost\SQLEXPRESS -E -d SvagsCorporateDb -i 02_CreateTables.sql

echo Inserting seed data...
sqlcmd -S localhost\SQLEXPRESS -E -d SvagsCorporateDb -i 03_InsertSeedData.sql

echo Verifying installation...
sqlcmd -S localhost\SQLEXPRESS -E -d SvagsCorporateDb -i 04_VerifyDatabase.sql

echo Setup complete!
pause
```

## 📊 Expected Results

After successful execution, you should have:

### Tables Created (17)
- **Content**: Products, Technologies, Solutions, Industries, NewsArticles
- **Company**: CompanyProfiles, CompanyValues, Milestones
- **Careers**: CareersInfos, Benefits, HiringSteps, JobPositions, CareerPrograms
- **Forms**: ContactSubmissions, NewsletterSubscribers, JobApplications

### Sample Data
- 2 Products (SVAGS, SVAGS Bulk Messaging)
- 15 Technologies
- 5 Solutions
- 5 Industries
- 3 News Articles
- 1 Company Profile with values and milestones
- 5 Job Positions
- 3 Career Programs

## 🔧 Database Connection

### Connection String for .NET Application

```csharp
Server=localhost\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;
```

### Update appsettings.json

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

## ✅ Verification Checklist

- [ ] Database `SvagsCorporateDb` exists in SQL Server
- [ ] All 17 tables are created
- [ ] Products table has 2 records
- [ ] Technologies table has 15 records
- [ ] JobPositions table has 5 records
- [ ] All foreign key relationships are in place
- [ ] Can connect with provided connection string

## 🔄 Reset/Cleanup (if needed)

If you need to start over:

```sql
-- Run this to drop and recreate everything
USE master;
GO
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SvagsCorporateDb')
BEGIN
    ALTER DATABASE [SvagsCorporateDb] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [SvagsCorporateDb];
    PRINT 'Database dropped!';
END
GO

-- Then re-execute the setup scripts
```

Or use the provided script: `00_DropDatabase.sql`

## 🚨 Troubleshooting

### Issue: "Cannot open file"
**Solution**: Verify the file path exists and you have read permissions

### Issue: "Login failed for user"
**Solution**: Check that Windows Authentication is enabled and you have admin rights

### Issue: "Cannot create database at the specified location"
**Solution**: The SQL Server data folder path may be different. Edit the path in `01_CreateDatabase.sql` before executing

### Issue: "Cannot open database"
**Solution**: Ensure the database was successfully created by checking SQL Server Object Explorer

### Issue: Connection timeout when running .NET app
**Solution**: 
1. Verify database is running
2. Check connection string spelling (especially backslash: `\\` in JSON)
3. Run `04_VerifyDatabase.sql` to confirm setup

## 📞 Next Steps

After database setup is complete:

1. **Start the .NET API**:
   ```bash
   cd C:\Sai\svags-corporate\backend\SvagsCorporate.Api
   dotnet run
   ```

2. **API will be available at**: `http://localhost:5080`

3. **Swagger documentation**: `http://localhost:5080/swagger`

4. **Update Angular frontend** to call the API instead of local JSON files

## 📝 Notes

- All scripts use SQL Server T-SQL syntax
- Assumes Windows Authentication
- Default instance path: `C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\`
- All timestamps stored in UTC (DATETIME2)
- All text fields support Unicode (NVARCHAR)
- JSON data stored in NVARCHAR fields

## 🆘 Getting Help

If you encounter issues:

1. Check the **Troubleshooting** section above
2. Run `04_VerifyDatabase.sql` to see the current state
3. Check SQL Server error logs
4. Verify SQL Server is running and accessible
5. Confirm firewall isn't blocking TCP/IP on port 1433

---

**Database Setup Created**: 2026-09-21  
**SVAGS Technologies**  
**Backend: .NET 10 + SQL Server**
