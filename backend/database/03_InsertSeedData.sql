-- Insert Seed Data into SVAGS Technologies Database
-- Execute this script after creating the tables

USE [SvagsCorporateDb];
GO

-- ============================================
-- Insert Products
-- ============================================
INSERT INTO [dbo].[Products] ([ExternalId], [Name], [Tagline], [Description], [Status], [Url], [Icon], [Color], [Technologies], [Features], [CreatedAt])
VALUES
(
    'svags',
    'SVAGS',
    'Smart Car Service Platform',
    'A modern, intelligent platform that connects car owners with trusted service centers. Streamline bookings, track repairs in real-time, and manage your vehicle''s entire service history — all in one place.',
    'live',
    'https://svags.com',
    'pi pi-car',
    '#009688',
    '["Angular","NET","Flutter","Azure","SQL Server","Redis"]',
    '["Real-time tracking","Smart booking","Service history","Multi-platform"]',
    GETUTCDATE()
),
(
    'svags-bulk-messaging',
    'SVAGS Bulk Messaging',
    'Bulk Messaging Software',
    'A powerful bulk messaging platform that enables businesses to send high-volume SMS, WhatsApp, and email campaigns with ease. Reach your audience instantly with smart delivery, analytics, and automation.',
    'live',
    NULL,
    'pi pi-send',
    '#F97316',
    '["Angular",".NET","Azure","SQL Server","Redis"]',
    '["Bulk SMS & WhatsApp","Email campaigns","Delivery analytics","Automation"]',
    GETUTCDATE()
);
GO

-- ============================================
-- Insert Technologies
-- ============================================
INSERT INTO [dbo].[Technologies] ([ExternalId], [Name], [Category], [Description], [Icon], [Color], [Proficiency])
VALUES
('angular', 'Angular', 'Frontend', 'Modern web framework for building single-page applications', 'pi pi-code', '#DD0031', 95),
('dotnet', '.NET 8', 'Backend', 'Enterprise framework for building scalable backend services', 'pi pi-server', '#512BD4', 95),
('flutter', 'Flutter', 'Mobile', 'Cross-platform mobile development framework', 'pi pi-mobile', '#02569B', 85),
('react', 'React', 'Frontend', 'JavaScript library for building user interfaces', 'pi pi-code', '#61DAFB', 80),
('azure', 'Microsoft Azure', 'Cloud', 'Cloud computing platform for hosting and scaling applications', 'pi pi-cloud', '#0078D4', 90),
('sqlserver', 'SQL Server', 'Database', 'Relational database management system', 'pi pi-database', '#CC2927', 95),
('redis', 'Redis', 'Cache', 'In-memory data structure store for caching', 'pi pi-flash', '#DC382D', 85),
('postgresql', 'PostgreSQL', 'Database', 'Advanced open-source relational database', 'pi pi-database', '#336791', 80),
('mongodb', 'MongoDB', 'Database', 'NoSQL document database for flexible schemas', 'pi pi-database', '#00ED64', 75),
('kubernetes', 'Kubernetes', 'DevOps', 'Container orchestration platform', 'pi pi-box', '#326CE5', 80),
('docker', 'Docker', 'DevOps', 'Containerization platform for applications', 'pi pi-box', '#2496ED', 85),
('azure-devops', 'Azure DevOps', 'DevOps', 'Tools for continuous integration and deployment', 'pi pi-cog', '#0078D4', 90),
('tailwind', 'Tailwind CSS', 'Frontend', 'Utility-first CSS framework', 'pi pi-palette', '#06B6D4', 85),
('typescript', 'TypeScript', 'Language', 'Typed superset of JavaScript', 'pi pi-code', '#3178C6', 95),
('git', 'Git', 'Version Control', 'Distributed version control system', 'pi pi-code-branch', '#F1502F', 95);
GO

-- ============================================
-- Insert Solutions
-- ============================================
INSERT INTO [dbo].[Solutions] ([ExternalId], [Title], [Description], [Icon], [Color], [Features])
VALUES
(
    'custom-development',
    'Custom Software Development',
    'Tailored software solutions built from the ground up to meet your specific business needs.',
    'pi pi-pencil',
    '#3B82F6',
    '["Requirement Analysis","Architecture Design","Development","Testing","Deployment"]'
),
(
    'web-development',
    'Web Development',
    'Modern, responsive web applications built with latest technologies and best practices.',
    'pi pi-globe',
    '#8B5CF6',
    '["Responsive Design","Progressive Web Apps","SEO Optimization","Performance Tuning"]'
),
(
    'mobile-development',
    'Mobile Development',
    'Native and cross-platform mobile applications for iOS and Android.',
    'pi pi-mobile',
    '#EC4899',
    '["iOS Development","Android Development","Cross-platform Apps","App Deployment"]'
),
(
    'cloud-solutions',
    'Cloud Solutions',
    'Scalable cloud infrastructure and migration services using Azure, AWS, and GCP.',
    'pi pi-cloud',
    '#06B6D4',
    '["Infrastructure Setup","Migration Services","Monitoring","Auto-scaling"]'
),
(
    'data-analytics',
    'Data & Analytics',
    'Extract insights from your data with advanced analytics and business intelligence solutions.',
    'pi pi-chart-bar',
    '#10B981',
    '["Data Warehousing","BI Dashboards","Data Visualization","Predictive Analytics"]'
);
GO

-- ============================================
-- Insert Industries
-- ============================================
INSERT INTO [dbo].[Industries] ([ExternalId], [Name], [Description], [Icon], [Color], [UseCases])
VALUES
(
    'ecommerce',
    'E-Commerce',
    'Build powerful online stores that scale with your business growth.',
    'pi pi-shopping-cart',
    '#F59E0B',
    '["Shopping Platforms","Marketplace Solutions","Payment Integration","Inventory Management"]'
),
(
    'fintech',
    'FinTech',
    'Secure and compliant financial technology solutions.',
    'pi pi-credit-card',
    '#3B82F6',
    '["Digital Banking","Payment Processing","Investment Platforms","Crypto Solutions"]'
),
(
    'healthcare',
    'Healthcare',
    'HIPAA-compliant healthcare applications and patient management systems.',
    'pi pi-heart',
    '#EF4444',
    '["Patient Management","Telemedicine","EMR Systems","Health Analytics"]'
),
(
    'education',
    'Education',
    'Modern learning platforms and educational technology solutions.',
    'pi pi-book',
    '#8B5CF6',
    '["Learning Management Systems","Virtual Classrooms","Student Portals","Assessment Tools"]'
),
(
    'manufacturing',
    'Manufacturing',
    'IoT and automation solutions for modern manufacturing operations.',
    'pi pi-cog',
    '#6366F1',
    '["Process Automation","Supply Chain","Quality Control","Production Planning"]'
);
GO

-- ============================================
-- Insert Company Profile
-- ============================================
INSERT INTO [dbo].[CompanyProfiles] ([Name], [Founded], [Headquarters], [Mission], [Vision], [Description])
VALUES
(
    'SVAGS TECHNOLOGIES',
    '2020',
    'India',
    'To build innovative software products that simplify everyday life and empower businesses worldwide.',
    'To be a globally recognized technology company known for innovation, quality, and customer success.',
    'SVAGS TECHNOLOGIES is a forward-thinking software development company dedicated to creating intelligent solutions that solve real-world problems. With a focus on innovation, quality, and customer success, we partner with businesses to transform their operations through cutting-edge technology.'
);
GO

-- Insert Company Values
INSERT INTO [dbo].[CompanyValues] ([CompanyProfileId], [ExternalId], [Title], [Description], [Icon], [Color])
SELECT
    (SELECT TOP 1 [Id] FROM [dbo].[CompanyProfiles]),
    [id],
    [title],
    [description],
    [icon],
    [color]
FROM (
    VALUES
    ('innovation', 'Innovation', 'We embrace new ideas and constantly push the boundaries of what''s possible.', 'pi pi-lightbulb', '#F59E0B'),
    ('quality', 'Quality', 'We deliver excellence in everything we do, from code to customer service.', 'pi pi-check-circle', '#10B981'),
    ('integrity', 'Integrity', 'We conduct our business with honesty, transparency, and strong ethical values.', 'pi pi-shield', '#3B82F6'),
    ('collaboration', 'Collaboration', 'We believe in the power of teamwork and open communication.', 'pi pi-users', '#8B5CF6')
) AS vals([id], [title], [description], [icon], [color]);
GO

-- Insert Milestones
INSERT INTO [dbo].[Milestones] ([CompanyProfileId], [Year], [Title], [Description])
SELECT
    (SELECT TOP 1 [Id] FROM [dbo].[CompanyProfiles]),
    [year],
    [title],
    [description]
FROM (
    VALUES
    ('2020', 'Founded', 'SVAGS TECHNOLOGIES was founded with a vision to revolutionize software development.'),
    ('2021', 'First Product Launch', 'Launched SVAGS - Smart Car Service Platform, our flagship product.'),
    ('2022', 'Team Growth', 'Expanded to 50+ talented developers and designers across India.'),
    ('2023', 'Global Expansion', 'Started serving customers across Asia and Southeast Asia.'),
    ('2024', 'New Solutions', 'Launched Bulk Messaging Platform and expanded service offerings.')
) AS vals([year], [title], [description]);
GO

-- ============================================
-- Insert Careers Information
-- ============================================
INSERT INTO [dbo].[CareersInfos] ([Headline], [Subheadline])
VALUES
(
    'Join Our Team',
    'Help us build technology that shapes tomorrow. We''re looking for talented, passionate individuals who want to make a real impact.'
);
GO

-- Insert Benefits
INSERT INTO [dbo].[Benefits] ([CareersInfoId], [Icon], [Title], [Description])
SELECT
    (SELECT TOP 1 [Id] FROM [dbo].[CareersInfos]),
    [icon],
    [title],
    [description]
FROM (
    VALUES
    ('pi pi-check-circle', 'Competitive Salary', 'Industry-leading compensation packages and performance bonuses.'),
    ('pi pi-home', 'Remote Friendly', 'Work from anywhere. We believe in flexibility and trust.'),
    ('pi pi-heart', 'Health & Wellness', 'Comprehensive health insurance and wellness programs.'),
    ('pi pi-graduation-cap', 'Learning & Growth', 'Budget for training, certifications, and professional development.'),
    ('pi pi-calendar', 'Work-Life Balance', 'Flexible working hours and generous leave policies.'),
    ('pi pi-gift', 'Perks & Benefits', 'Team outings, tech gadgets, and exciting company events.')
) AS vals([icon], [title], [description]);
GO

-- Insert Hiring Steps
INSERT INTO [dbo].[HiringSteps] ([CareersInfoId], [Step], [Title], [Description])
SELECT
    (SELECT TOP 1 [Id] FROM [dbo].[CareersInfos]),
    [step],
    [title],
    [description]
FROM (
    VALUES
    (1, 'Application Review', 'We review your resume and application to understand your background and skills.'),
    (2, 'Initial Screening', 'A quick chat with our HR team to discuss the role and your expectations.'),
    (3, 'Technical Assessment', 'Show us your technical skills through our coding challenge or portfolio review.'),
    (4, 'Team Interview', 'Meet with the team leads to discuss your experience and potential impact.'),
    (5, 'Offer & Onboarding', 'If we''re a perfect match, we''ll make an offer and get you started!')
) AS vals([step], [title], [description]);
GO

-- Insert Job Positions
INSERT INTO [dbo].[JobPositions] ([CareersInfoId], [ExternalId], [Title], [Department], [Type], [Location], [Experience], [Description])
SELECT
    (SELECT TOP 1 [Id] FROM [dbo].[CareersInfos]),
    [id],
    [title],
    [department],
    [type],
    [location],
    [experience],
    [description]
FROM (
    VALUES
    ('senior-angular-dev', 'Senior Angular Developer', 'Engineering', 'Full-time', 'Bangalore, India', '5+ years', 'We''re looking for an experienced Angular developer to lead our frontend development efforts.'),
    ('dotnet-backend-dev', '.NET Backend Developer', 'Engineering', 'Full-time', 'Bangalore, India', '3+ years', 'Join our backend team and build scalable APIs with .NET and SQL Server.'),
    ('flutter-mobile-dev', 'Flutter Developer', 'Engineering', 'Full-time', 'Remote', '3+ years', 'Build beautiful cross-platform mobile applications with Flutter.'),
    ('qa-engineer', 'QA Engineer', 'Quality', 'Full-time', 'Bangalore, India', '2+ years', 'Ensure quality through comprehensive testing and automation.'),
    ('devops-engineer', 'DevOps Engineer', 'Infrastructure', 'Full-time', 'Remote', '3+ years', 'Manage our cloud infrastructure and CI/CD pipelines.')
) AS vals([id], [title], [department], [type], [location], [experience], [description]);
GO

-- Insert Career Programs
INSERT INTO [dbo].[CareerPrograms] ([CareersInfoId], [ExternalId], [Title], [Description], [Icon])
SELECT
    (SELECT TOP 1 [Id] FROM [dbo].[CareersInfos]),
    [id],
    [title],
    [description],
    [icon]
FROM (
    VALUES
    ('fresher-program', 'Fresher Program', 'Kick-start your career with our mentorship-driven fresher program. We invest in talented graduates and provide comprehensive training.', 'pi pi-star'),
    ('internship', 'Internship Program', 'Gain real-world experience by working on actual projects with our experienced team members.', 'pi pi-briefcase'),
    ('contractor', 'Contractor Program', 'Flexible opportunities for experienced professionals looking to work on specific projects.', 'pi pi-handshake')
) AS vals([id], [title], [description], [icon]);
GO

-- ============================================
-- Insert News Articles
-- ============================================
INSERT INTO [dbo].[NewsArticles] ([ExternalId], [Title], [Excerpt], [Category], [Date], [ReadTime], [Featured], [Tags])
VALUES
(
    'news-1',
    'Introducing SVAGS Bulk Messaging Platform',
    'Announcing the launch of our new Bulk Messaging Platform designed to help businesses reach their customers instantly.',
    'Product Launch',
    '2024-09-15',
    '5 min read',
    1,
    '["Product","Launch","Messaging"]'
),
(
    'news-2',
    'How SVAGS is Transforming Car Service Industry',
    'Learn how SVAGS platform is revolutionizing the way car owners book and manage their vehicle services.',
    'Case Study',
    '2024-09-10',
    '8 min read',
    1,
    '["SVAGS","CaseStudy","Innovation"]'
),
(
    'news-3',
    'Top 5 Web Development Trends in 2024',
    'Explore the latest web development trends that are shaping the future of the internet.',
    'Technology',
    '2024-09-05',
    '6 min read',
    0,
    '["WebDevelopment","Trends","Technology"]'
);
GO

PRINT 'All seed data inserted successfully!';
GO
