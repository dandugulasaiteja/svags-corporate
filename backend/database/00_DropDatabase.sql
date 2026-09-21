-- Drop SVAGS Technologies Database (CLEANUP/RESET)
-- WARNING: This script will delete the entire database and all data!
-- Only execute if you want to reset the database

USE master;
GO

PRINT 'WARNING: This will delete the entire SvagsCorporateDb database!';
PRINT 'All data will be permanently lost.';
PRINT '';

-- Drop database if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SvagsCorporateDb')
BEGIN
    PRINT 'Dropping database [SvagsCorporateDb]...';

    -- Set to single user mode to close all connections
    ALTER DATABASE [SvagsCorporateDb] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    -- Drop the database
    DROP DATABASE [SvagsCorporateDb];

    PRINT 'Database [SvagsCorporateDb] dropped successfully!';
    PRINT '';
    PRINT 'To recreate the database, execute the following scripts in order:';
    PRINT '1. 01_CreateDatabase.sql';
    PRINT '2. 02_CreateTables.sql';
    PRINT '3. 03_InsertSeedData.sql';
END
ELSE
BEGIN
    PRINT 'Database [SvagsCorporateDb] does not exist.';
END
GO
