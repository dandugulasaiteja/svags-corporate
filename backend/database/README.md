# SVAGS Technologies Database Setup

This folder contains SQL Server database setup scripts for the SVAGS Technologies corporate website backend.

## Database Scripts

### Execution Order

Execute the SQL scripts in the following order:

1. **01_CreateDatabase.sql** - Creates the `SvagsCorporateDb` database
   **Local/on-prem SQL Server only** (e.g. SQLEXPRESS). Skip this on Azure SQL
   Database — Azure SQL is provisioned via the Azure control plane
   (`az sql db create` or the Portal), not a raw `CREATE DATABASE` with
   physical file paths.
2. **02_CreateTables.sql** - Creates all tables with relationships and indexes.
   Works unchanged on both local SQL Server and Azure SQL Database.
3. **03_InsertSeedData.sql** - Inserts seed data mirroring
   `backend/SvagsCorporate.Api/Data/SeedData/*.json`. Works unchanged on both.
4. **04_VerifyDatabase.sql** - Verifies tables, indexes, foreign keys, and
   seed data landed correctly. Works unchanged on both.

On Azure SQL, connect SSMS/Azure Data Studio/`sqlcmd` directly to
`<your-server>.database.windows.net` with the `SvagsCorporateDb` database
already created, and run scripts 2-4 only.

## How to Execute

### Option 1: Using SQL Server Management Studio (SSMS)

1. Open **SQL Server Management Studio**
2. Connect to your SQL Server instance
3. Click **File > Open > Query File**
4. Select **01_CreateDatabase.sql**
5. Click **Execute** (or press F5)
6. Repeat steps 3-5 for **02_CreateTables.sql**
7. Repeat steps 3-5 for **03_InsertSeedData.sql**

### Option 2: Using Command Line (sqlcmd)

```batch
# Navigate to the backend folder
cd C:\Sai\svags-corporate\backend\database

# Execute database creation
sqlcmd -S localhost\SQLEXPRESS -E -i 01_CreateDatabase.sql

# Execute table creation
sqlcmd -S localhost\SQLEXPRESS -E -d SvagsCorporateDb -i 02_CreateTables.sql

# Execute seed data insertion
sqlcmd -S localhost\SQLEXPRESS -E -d SvagsCorporateDb -i 03_InsertSeedData.sql
```

### Option 2b: Against Azure SQL Database

The database itself is provisioned via the Azure control plane, not
`01_CreateDatabase.sql` — see the note in Execution Order above. Once
`SvagsCorporateDb` exists on your Azure SQL logical server, run scripts 2-4
with SQL authentication (Azure SQL doesn't support Windows/Trusted auth):

```bash
sqlcmd -S <your-server>.database.windows.net -d SvagsCorporateDb -U <admin-user> -P "<password>" -i 02_CreateTables.sql
sqlcmd -S <your-server>.database.windows.net -d SvagsCorporateDb -U <admin-user> -P "<password>" -i 03_InsertSeedData.sql
sqlcmd -S <your-server>.database.windows.net -d SvagsCorporateDb -U <admin-user> -P "<password>" -i 04_VerifyDatabase.sql
```

Your Azure SQL Server firewall must allow your current IP (see the
`AllowMyIP` firewall rule when you provisioned the server) or these will
time out before they even reach the syntax.

### Option 3: Using PowerShell

```powershell
# Execute database creation
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -InputFile "01_CreateDatabase.sql"

# Execute table creation
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -Database "SvagsCorporateDb" -InputFile "02_CreateTables.sql"

# Execute seed data insertion
Invoke-Sqlcmd -ServerInstance "localhost\SQLEXPRESS" -Database "SvagsCorporateDb" -InputFile "03_InsertSeedData.sql"
```

## Database Structure

### Content Tables
- **Products** - Product/solution information
- **Technologies** - Tech stack and tools
- **Solutions** - Service offerings
- **Industries** - Industry verticals
- **NewsArticles** - News and blog articles

### Company Tables
- **CompanyProfiles** - Company information
- **CompanyValues** - Core values
- **Milestones** - Company milestones

### Careers Tables
- **CareersInfos** - Careers page content
- **Benefits** - Employee benefits
- **HiringSteps** - Hiring process steps
- **JobPositions** - Open job positions
- **CareerPrograms** - Recruitment programs

### Form Submission Tables
- **ContactSubmissions** - Contact form submissions
- **NewsletterSubscribers** - Newsletter subscribers
- **JobApplications** - Job applications with resume files

## Database Configuration

### Connection String

```
Server=localhost\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;
```

Use this connection string in your .NET application's `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=SvagsCorporateDb;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

## Important Notes

1. **LocalDB Path**: The scripts assume SQL Server data files are at:
   - `C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\`
   
   Adjust the path in **01_CreateDatabase.sql** if your SQL Server instance is in a different location.

2. **Database Name**: The database will be created with the name `SvagsCorporateDb`

3. **Authentication**: The scripts use Windows Authentication. Make sure your user has appropriate permissions.

4. **Data Persistence**: The seed data includes:
   - 1 product (SVAGS — the only product launched to date)
   - 33 technologies
   - 6 solutions
   - 6 industries
   - 2 news articles
   - Company profile with values and milestones
   - Careers information with positions and programs

## Verify Installation

After executing all scripts, verify the database setup:

```sql
-- Connect to SvagsCorporateDb and run:
SELECT 
    'Products' AS TableName, COUNT(*) AS RecordCount FROM [Products]
UNION ALL
SELECT 'Technologies', COUNT(*) FROM [Technologies]
UNION ALL
SELECT 'Solutions', COUNT(*) FROM [Solutions]
UNION ALL
SELECT 'Industries', COUNT(*) FROM [Industries]
UNION ALL
SELECT 'NewsArticles', COUNT(*) FROM [NewsArticles]
UNION ALL
SELECT 'CompanyProfiles', COUNT(*) FROM [CompanyProfiles]
UNION ALL
SELECT 'JobPositions', COUNT(*) FROM [JobPositions];
```

Expected output:
```
Products        1
Technologies    33
Solutions       6
Industries      6
NewsArticles    2
CompanyProfiles 1
JobPositions    4
```

## Next Steps

After setting up the database:

1. Start the .NET API server:
   ```bash
   cd C:\Sai\svags-corporate\backend\SvagsCorporate.Api
   dotnet run
   ```

2. The API will be available at `http://localhost:5080`

3. Swagger UI documentation: `http://localhost:5080/swagger`

4. Update your Angular app to use the API endpoints instead of local JSON files.

## Support

For issues or questions about the database setup, please contact the development team.
