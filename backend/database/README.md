# SVAGS Technologies Database Setup

This folder contains SQL Server database setup scripts for the SVAGS Technologies corporate website backend.

## Database Scripts

### Execution Order

Execute the SQL scripts in the following order:

1. **01_CreateDatabase.sql** - Creates the `SvagsCorporateDb` database
2. **02_CreateTables.sql** - Creates all tables with relationships and indexes
3. **03_InsertSeedData.sql** - Inserts seed data from the application

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
   - 2 products (SVAGS, SVAGS Bulk Messaging)
   - 15 technologies
   - 5 solutions
   - 5 industries
   - 3 news articles
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
Products        2
Technologies    15
Solutions       5
Industries      5
NewsArticles    3
CompanyProfiles 1
JobPositions    5
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
