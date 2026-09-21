-- Create SVAGS Technologies Database Tables
-- Execute this script after creating the database

USE [SvagsCorporateDb];
GO

-- ============================================
-- Content Tables
-- ============================================

-- Products Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Products')
BEGIN
    CREATE TABLE [dbo].[Products] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [ExternalId] NVARCHAR(100) NULL,
        [Name] NVARCHAR(255) NOT NULL,
        [Tagline] NVARCHAR(500) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        [Status] NVARCHAR(50) NOT NULL,
        [Url] NVARCHAR(500) NULL,
        [Icon] NVARCHAR(100) NOT NULL,
        [Color] NVARCHAR(50) NOT NULL,
        [Technologies] NVARCHAR(MAX) NOT NULL,
        [Features] NVARCHAR(MAX) NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT [UK_Products_ExternalId] UNIQUE ([ExternalId])
    );
    CREATE INDEX [IX_Products_Status] ON [dbo].[Products]([Status]);
END
GO

-- Technologies Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Technologies')
BEGIN
    CREATE TABLE [dbo].[Technologies] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [ExternalId] NVARCHAR(100) NULL,
        [Name] NVARCHAR(255) NOT NULL,
        [Category] NVARCHAR(100) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        [Icon] NVARCHAR(100) NOT NULL,
        [Color] NVARCHAR(50) NOT NULL,
        [Proficiency] INT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
    CREATE INDEX [IX_Technologies_Category] ON [dbo].[Technologies]([Category]);
END
GO

-- Solutions Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Solutions')
BEGIN
    CREATE TABLE [dbo].[Solutions] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [ExternalId] NVARCHAR(100) NULL,
        [Title] NVARCHAR(255) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        [Icon] NVARCHAR(100) NOT NULL,
        [Color] NVARCHAR(50) NOT NULL,
        [Features] NVARCHAR(MAX) NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
END
GO

-- Industries Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Industries')
BEGIN
    CREATE TABLE [dbo].[Industries] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [ExternalId] NVARCHAR(100) NULL,
        [Name] NVARCHAR(255) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        [Icon] NVARCHAR(100) NOT NULL,
        [Color] NVARCHAR(50) NOT NULL,
        [UseCases] NVARCHAR(MAX) NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
END
GO

-- News Articles Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'NewsArticles')
BEGIN
    CREATE TABLE [dbo].[NewsArticles] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [ExternalId] NVARCHAR(100) NULL,
        [Title] NVARCHAR(500) NOT NULL,
        [Excerpt] NVARCHAR(1000) NOT NULL,
        [Category] NVARCHAR(100) NOT NULL,
        [Date] NVARCHAR(50) NOT NULL,
        [ReadTime] NVARCHAR(50) NOT NULL,
        [Featured] BIT NOT NULL DEFAULT 0,
        [Tags] NVARCHAR(MAX) NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
    CREATE INDEX [IX_NewsArticles_Featured] ON [dbo].[NewsArticles]([Featured]);
    CREATE INDEX [IX_NewsArticles_Category] ON [dbo].[NewsArticles]([Category]);
END
GO

-- ============================================
-- Company Tables
-- ============================================

-- Company Profiles Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CompanyProfiles')
BEGIN
    CREATE TABLE [dbo].[CompanyProfiles] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [Name] NVARCHAR(255) NOT NULL,
        [Founded] NVARCHAR(50) NOT NULL,
        [Headquarters] NVARCHAR(255) NOT NULL,
        [Mission] NVARCHAR(MAX) NOT NULL,
        [Vision] NVARCHAR(MAX) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
END
GO

-- Company Values Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CompanyValues')
BEGIN
    CREATE TABLE [dbo].[CompanyValues] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [CompanyProfileId] INT NOT NULL,
        [ExternalId] NVARCHAR(100) NULL,
        [Title] NVARCHAR(255) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        [Icon] NVARCHAR(100) NOT NULL,
        [Color] NVARCHAR(50) NOT NULL,
        CONSTRAINT [FK_CompanyValues_CompanyProfiles] FOREIGN KEY ([CompanyProfileId])
            REFERENCES [dbo].[CompanyProfiles]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX [IX_CompanyValues_CompanyProfileId] ON [dbo].[CompanyValues]([CompanyProfileId]);
END
GO

-- Milestones Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Milestones')
BEGIN
    CREATE TABLE [dbo].[Milestones] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [CompanyProfileId] INT NOT NULL,
        [Year] NVARCHAR(50) NOT NULL,
        [Title] NVARCHAR(255) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        CONSTRAINT [FK_Milestones_CompanyProfiles] FOREIGN KEY ([CompanyProfileId])
            REFERENCES [dbo].[CompanyProfiles]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX [IX_Milestones_CompanyProfileId] ON [dbo].[Milestones]([CompanyProfileId]);
END
GO

-- ============================================
-- Careers Tables
-- ============================================

-- Careers Info Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CareersInfos')
BEGIN
    CREATE TABLE [dbo].[CareersInfos] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [Headline] NVARCHAR(500) NOT NULL,
        [Subheadline] NVARCHAR(MAX) NOT NULL,
        [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
END
GO

-- Benefits Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Benefits')
BEGIN
    CREATE TABLE [dbo].[Benefits] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [CareersInfoId] INT NOT NULL,
        [Icon] NVARCHAR(100) NOT NULL,
        [Title] NVARCHAR(255) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        CONSTRAINT [FK_Benefits_CareersInfos] FOREIGN KEY ([CareersInfoId])
            REFERENCES [dbo].[CareersInfos]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX [IX_Benefits_CareersInfoId] ON [dbo].[Benefits]([CareersInfoId]);
END
GO

-- Hiring Steps Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HiringSteps')
BEGIN
    CREATE TABLE [dbo].[HiringSteps] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [CareersInfoId] INT NOT NULL,
        [Step] INT NOT NULL,
        [Title] NVARCHAR(255) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        CONSTRAINT [FK_HiringSteps_CareersInfos] FOREIGN KEY ([CareersInfoId])
            REFERENCES [dbo].[CareersInfos]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX [IX_HiringSteps_CareersInfoId] ON [dbo].[HiringSteps]([CareersInfoId]);
END
GO

-- Job Positions Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'JobPositions')
BEGIN
    CREATE TABLE [dbo].[JobPositions] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [CareersInfoId] INT NOT NULL,
        [ExternalId] NVARCHAR(100) NULL,
        [Title] NVARCHAR(255) NOT NULL,
        [Department] NVARCHAR(100) NOT NULL,
        [Type] NVARCHAR(50) NOT NULL,
        [Location] NVARCHAR(255) NOT NULL,
        [Experience] NVARCHAR(100) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT [FK_JobPositions_CareersInfos] FOREIGN KEY ([CareersInfoId])
            REFERENCES [dbo].[CareersInfos]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX [IX_JobPositions_CareersInfoId] ON [dbo].[JobPositions]([CareersInfoId]);
    CREATE INDEX [IX_JobPositions_Department] ON [dbo].[JobPositions]([Department]);
END
GO

-- Career Programs Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CareerPrograms')
BEGIN
    CREATE TABLE [dbo].[CareerPrograms] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [CareersInfoId] INT NOT NULL,
        [ExternalId] NVARCHAR(100) NULL,
        [Title] NVARCHAR(255) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        [Icon] NVARCHAR(100) NOT NULL,
        CONSTRAINT [FK_CareerPrograms_CareersInfos] FOREIGN KEY ([CareersInfoId])
            REFERENCES [dbo].[CareersInfos]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX [IX_CareerPrograms_CareersInfoId] ON [dbo].[CareerPrograms]([CareersInfoId]);
END
GO

-- ============================================
-- Form Submission Tables
-- ============================================

-- Contact Submissions Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ContactSubmissions')
BEGIN
    CREATE TABLE [dbo].[ContactSubmissions] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [Name] NVARCHAR(255) NOT NULL,
        [Email] NVARCHAR(255) NOT NULL,
        [Company] NVARCHAR(255) NULL,
        [Subject] NVARCHAR(500) NOT NULL,
        [Message] NVARCHAR(MAX) NOT NULL,
        [IpAddress] NVARCHAR(50) NULL,
        [EmailSent] BIT NOT NULL DEFAULT 0,
        [SubmittedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
    CREATE INDEX [IX_ContactSubmissions_Email] ON [dbo].[ContactSubmissions]([Email]);
    CREATE INDEX [IX_ContactSubmissions_SubmittedAt] ON [dbo].[ContactSubmissions]([SubmittedAt]);
END
GO

-- Newsletter Subscribers Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'NewsletterSubscribers')
BEGIN
    CREATE TABLE [dbo].[NewsletterSubscribers] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [Email] NVARCHAR(255) NOT NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [IpAddress] NVARCHAR(50) NULL,
        [SubscribedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UnsubscribedAt] DATETIME2 NULL,
        CONSTRAINT [UK_NewsletterSubscribers_Email] UNIQUE ([Email])
    );
    CREATE INDEX [IX_NewsletterSubscribers_IsActive] ON [dbo].[NewsletterSubscribers]([IsActive]);
END
GO

-- Job Applications Table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'JobApplications')
BEGIN
    CREATE TABLE [dbo].[JobApplications] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [Name] NVARCHAR(255) NOT NULL,
        [Email] NVARCHAR(255) NOT NULL,
        [Phone] NVARCHAR(20) NOT NULL,
        [JobPositionId] INT NULL,
        [PositionTitle] NVARCHAR(255) NULL,
        [Message] NVARCHAR(MAX) NOT NULL,
        [ResumeFilePath] NVARCHAR(MAX) NULL,
        [IpAddress] NVARCHAR(50) NULL,
        [EmailSent] BIT NOT NULL DEFAULT 0,
        [AppliedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT [FK_JobApplications_JobPositions] FOREIGN KEY ([JobPositionId])
            REFERENCES [dbo].[JobPositions]([Id]) ON DELETE SET NULL
    );
    CREATE INDEX [IX_JobApplications_Email] ON [dbo].[JobApplications]([Email]);
    CREATE INDEX [IX_JobApplications_JobPositionId] ON [dbo].[JobApplications]([JobPositionId]);
    CREATE INDEX [IX_JobApplications_AppliedAt] ON [dbo].[JobApplications]([AppliedAt]);
END
GO

PRINT 'All tables created successfully!';
GO
