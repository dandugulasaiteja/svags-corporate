-- Create SVAGS Technologies Database
-- Execute this script to create the database

USE master;
GO

-- Drop database if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SvagsCorporateDb')
BEGIN
    ALTER DATABASE [SvagsCorporateDb] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [SvagsCorporateDb];
END
GO

-- Create database
CREATE DATABASE [SvagsCorporateDb]
    CONTAINMENT = NONE
    ON PRIMARY
    (
        NAME = N'SvagsCorporateDb',
        FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SvagsCorporateDb.mdf',
        SIZE = 10MB,
        FILEGROWTH = 10%
    )
    LOG ON
    (
        NAME = N'SvagsCorporateDb_log',
        FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SvagsCorporateDb_log.ldf',
        SIZE = 5MB,
        FILEGROWTH = 10%
    );
GO

-- Set database options
ALTER DATABASE [SvagsCorporateDb] SET COMPATIBILITY_LEVEL = 160;
ALTER DATABASE [SvagsCorporateDb] SET ANSI_NULL_DEFAULT ON;
ALTER DATABASE [SvagsCorporateDb] SET ANSI_NULLS ON;
ALTER DATABASE [SvagsCorporateDb] SET ANSI_PADDING ON;
ALTER DATABASE [SvagsCorporateDb] SET ANSI_WARNINGS ON;
ALTER DATABASE [SvagsCorporateDb] SET ARITHABORT ON;
ALTER DATABASE [SvagsCorporateDb] SET AUTO_CLOSE OFF;
ALTER DATABASE [SvagsCorporateDb] SET AUTO_SHRINK OFF;
ALTER DATABASE [SvagsCorporateDb] SET AUTO_UPDATE_STATISTICS ON;
ALTER DATABASE [SvagsCorporateDb] SET CURSOR_CLOSE_ON_COMMIT OFF;
ALTER DATABASE [SvagsCorporateDb] SET CURSOR_DEFAULT GLOBAL;
ALTER DATABASE [SvagsCorporateDb] SET CONCAT_NULL_YIELDS_NULL ON;
ALTER DATABASE [SvagsCorporateDb] SET NUMERIC_ROUNDABORT OFF;
ALTER DATABASE [SvagsCorporateDb] SET QUOTED_IDENTIFIER ON;
ALTER DATABASE [SvagsCorporateDb] SET RECURSIVE_TRIGGERS OFF;
ALTER DATABASE [SvagsCorporateDb] SET DISABLE_NEO_INITIALIZATION = OFF;
ALTER DATABASE [SvagsCorporateDb] SET ALLOW_SNAPSHOT_ISOLATION ON;
ALTER DATABASE [SvagsCorporateDb] SET READ_COMMITTED_SNAPSHOT ON;
GO

PRINT 'Database [SvagsCorporateDb] created successfully!';
GO
