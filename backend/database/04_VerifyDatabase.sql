-- Verify SVAGS Technologies Database Setup
-- Run this script to verify the database was created correctly

USE [SvagsCorporateDb];
GO

PRINT '=== Database Verification Report ===';
PRINT '';

-- Check if database exists
PRINT 'Checking database existence...';
IF DB_NAME() = 'SvagsCorporateDb'
BEGIN
    PRINT 'STATUS: Database exists ✓';
END
ELSE
BEGIN
    PRINT 'ERROR: Database not found!';
END
GO

PRINT '';
PRINT 'Checking table creation...';
GO

-- Table existence check
DECLARE @TableCount INT;
SELECT @TableCount = COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

PRINT 'Total tables created: ' + CAST(@TableCount AS NVARCHAR(10));

-- List all tables
SELECT
    TABLE_NAME AS 'Table Name',
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_NAME = t.TABLE_NAME) AS 'Column Count'
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

GO

PRINT '';
PRINT 'Checking seed data...';
GO

-- Data count verification
SELECT
    'Products' AS TableName,
    COUNT(*) AS RecordCount
FROM [dbo].[Products]
UNION ALL
SELECT 'Technologies', COUNT(*) FROM [dbo].[Technologies]
UNION ALL
SELECT 'Solutions', COUNT(*) FROM [dbo].[Solutions]
UNION ALL
SELECT 'Industries', COUNT(*) FROM [dbo].[Industries]
UNION ALL
SELECT 'NewsArticles', COUNT(*) FROM [dbo].[NewsArticles]
UNION ALL
SELECT 'CompanyProfiles', COUNT(*) FROM [dbo].[CompanyProfiles]
UNION ALL
SELECT 'CompanyValues', COUNT(*) FROM [dbo].[CompanyValues]
UNION ALL
SELECT 'Milestones', COUNT(*) FROM [dbo].[Milestones]
UNION ALL
SELECT 'CareersInfos', COUNT(*) FROM [dbo].[CareersInfos]
UNION ALL
SELECT 'Benefits', COUNT(*) FROM [dbo].[Benefits]
UNION ALL
SELECT 'HiringSteps', COUNT(*) FROM [dbo].[HiringSteps]
UNION ALL
SELECT 'JobPositions', COUNT(*) FROM [dbo].[JobPositions]
UNION ALL
SELECT 'CareerPrograms', COUNT(*) FROM [dbo].[CareerPrograms]
UNION ALL
SELECT 'ContactSubmissions', COUNT(*) FROM [dbo].[ContactSubmissions]
UNION ALL
SELECT 'NewsletterSubscribers', COUNT(*) FROM [dbo].[NewsletterSubscribers]
UNION ALL
SELECT 'JobApplications', COUNT(*) FROM [dbo].[JobApplications]
ORDER BY TableName;

GO

PRINT '';
PRINT 'Checking indexes...';
GO

-- List indexes
SELECT
    t.name AS 'Table',
    i.name AS 'Index Name',
    'Clustered' AS 'Type'
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
WHERE i.type = 1 AND t.name LIKE 'Products' OR t.name LIKE 'Technologies' OR t.name LIKE 'NewsletterSubscribers'
ORDER BY t.name, i.name;

GO

PRINT '';
PRINT 'Checking relationships (Foreign Keys)...';
GO

-- List foreign keys
SELECT
    OBJECT_NAME(fk.parent_object_id) AS 'Table',
    fk.name AS 'Foreign Key',
    OBJECT_NAME(fk.referenced_object_id) AS 'References'
FROM sys.foreign_keys fk
ORDER BY OBJECT_NAME(fk.parent_object_id);

GO

PRINT '';
PRINT 'Sample Data Queries:';
PRINT '';

-- Sample Products
PRINT '--- Products ---';
SELECT TOP 2 [ExternalId], [Name], [Tagline], [Status] FROM [dbo].[Products];

PRINT '';
PRINT '--- Technologies ---';
SELECT TOP 3 [Name], [Category], [Color] FROM [dbo].[Technologies];

PRINT '';
PRINT '--- Job Positions ---';
SELECT TOP 3 [Title], [Department], [Location], [Experience] FROM [dbo].[JobPositions];

PRINT '';
PRINT '--- News Articles ---';
SELECT TOP 2 [Title], [Category], [Date] FROM [dbo].[NewsArticles];

PRINT '';
PRINT '=== Verification Complete ===';
PRINT 'If all tables exist and contain expected data, the database setup is successful!';
GO
