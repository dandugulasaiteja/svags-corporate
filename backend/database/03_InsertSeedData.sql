-- Insert Seed Data into SVAGS Technologies Database
-- Execute this script after creating the tables
-- NOTE: This mirrors backend/SvagsCorporate.Api/Data/SeedData/*.json exactly.
-- If the API's automatic seeding (DbInitializer) already ran, do not run this too.

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
    '["Angular",".NET","Flutter","Azure","SQL Server","Redis"]',
    '["Real-time tracking","Smart booking","Service history","Web, Android & iOS apps"]',
    GETUTCDATE()
);
GO

-- ============================================
-- Insert Technologies
-- ============================================
INSERT INTO [dbo].[Technologies] ([ExternalId], [Name], [Category], [Description], [Icon], [Color], [Proficiency])
VALUES
('angular', 'Angular', 'Frontend', 'Enterprise-grade web framework for building scalable, high-performance applications with TypeScript.', 'assets/icons/angular.svg', '#DD0031', NULL),
('react', 'React', 'Frontend', 'A declarative, component-based JavaScript library for building fast and interactive user interfaces.', 'assets/icons/react.svg', '#61DAFB', NULL),
('vuejs', 'Vue.js', 'Frontend', 'Progressive JavaScript framework for building modern, reactive web interfaces with simplicity.', 'assets/icons/vue.svg', '#42B883', NULL),
('nextjs', 'Next.js', 'Frontend', 'React framework with server-side rendering, static generation, and full-stack capabilities.', 'assets/icons/nextjs.svg', '#000000', NULL),
('typescript', 'TypeScript', 'Frontend', 'Strongly typed superset of JavaScript that improves code quality, maintainability, and developer experience.', 'assets/icons/typescript.svg', '#3178C6', NULL),
('dotnet', '.NET', 'Backend', 'Microsoft''s powerful cross-platform framework for building robust APIs and enterprise backend services.', 'assets/icons/dotnet.svg', '#512BD4', NULL),
('nodejs', 'Node.js', 'Backend', 'JavaScript runtime built on Chrome''s V8 engine for building fast, scalable server-side applications.', 'assets/icons/nodejs.svg', '#339933', NULL),
('python', 'Python', 'Backend', 'Versatile, high-level programming language widely used for web development, automation, data science, and AI.', 'assets/icons/python.svg', '#3776AB', NULL),
('java', 'Java', 'Backend', 'Robust, object-oriented programming language for building enterprise-grade, cross-platform applications.', 'assets/icons/java.svg', '#ED8B00', NULL),
('go', 'Go', 'Backend', 'Google''s statically typed, compiled language designed for simplicity, performance, and concurrency.', 'assets/icons/go.svg', '#00ADD8', NULL),
('rust', 'Rust', 'Backend', 'Systems programming language focused on safety, speed, and concurrency without a garbage collector.', 'assets/icons/rust.svg', '#CE422B', NULL),
('flutter', 'Flutter', 'Mobile', 'Google''s UI toolkit for crafting beautiful, natively compiled mobile applications from a single codebase.', 'assets/icons/flutter.svg', '#02569B', NULL),
('reactnative', 'React Native', 'Mobile', 'Build native mobile apps for iOS and Android using React and JavaScript with near-native performance.', 'assets/icons/react.svg', '#61DAFB', NULL),
('swift', 'Swift', 'Mobile', 'Apple''s powerful and intuitive programming language for building native iOS and macOS applications.', 'assets/icons/swift.svg', '#FA7343', NULL),
('kotlin', 'Kotlin', 'Mobile', 'Modern, concise programming language for Android development, fully interoperable with Java.', 'assets/icons/kotlin.svg', '#7F52FF', NULL),
('azure', 'Azure', 'Cloud', 'Microsoft Azure cloud platform powering our infrastructure with enterprise-grade reliability and global scale.', 'assets/icons/azure.svg', '#0078D4', NULL),
('aws', 'AWS', 'Cloud', 'Amazon Web Services — the world''s most comprehensive and broadly adopted cloud platform.', 'assets/icons/aws.svg', '#FF9900', NULL),
('gcp', 'Google Cloud', 'Cloud', 'Google Cloud Platform offering computing, storage, and application services for modern workloads.', 'assets/icons/gcp.svg', '#4285F4', NULL),
('sqlserver', 'SQL Server', 'Database', 'Microsoft''s enterprise relational database management system for mission-critical data workloads.', 'assets/icons/sqlserver.svg', '#CC2927', NULL),
('postgresql', 'PostgreSQL', 'Database', 'Powerful, open-source object-relational database system known for reliability and advanced features.', 'assets/icons/postgresql.svg', '#336791', NULL),
('mongodb', 'MongoDB', 'Database', 'Leading NoSQL document database for modern applications requiring flexible, scalable data storage.', 'assets/icons/mongodb.svg', '#47A248', NULL),
('mysql', 'MySQL', 'Database', 'The world''s most popular open-source relational database, trusted by millions of applications globally.', 'assets/icons/mysql.svg', '#4479A1', NULL),
('redis', 'Redis', 'Database', 'In-memory data structure store used for caching, session management, and real-time data processing.', 'assets/icons/redis.svg', '#DC382D', NULL),
('elasticsearch', 'Elasticsearch', 'Database', 'Distributed search and analytics engine for full-text search, log analytics, and real-time insights.', 'assets/icons/elasticsearch.svg', '#005571', NULL),
('docker', 'Docker', 'DevOps', 'Container platform for packaging applications and dependencies into portable, isolated environments.', 'assets/icons/docker.svg', '#2496ED', NULL),
('kubernetes', 'Kubernetes', 'DevOps', 'Open-source container orchestration system for automating deployment, scaling, and management of applications.', 'assets/icons/kubernetes.svg', '#326CE5', NULL),
('github-actions', 'GitHub Actions', 'DevOps', 'Automated CI/CD pipelines for continuous integration, testing, and deployment workflows.', 'assets/icons/github.svg', '#24292E', NULL),
('terraform', 'Terraform', 'DevOps', 'Infrastructure as Code tool for building, changing, and versioning cloud infrastructure safely and efficiently.', 'assets/icons/terraform.svg', '#7B42BC', NULL),
('signalr', 'SignalR', 'Real-time', 'ASP.NET library for adding real-time web functionality, enabling server-to-client push communications.', 'assets/icons/signalr.svg', '#512BD4', NULL),
('graphql', 'GraphQL', 'Real-time', 'Query language for APIs that gives clients the power to ask for exactly the data they need.', 'assets/icons/graphql.svg', '#E10098', NULL),
('ai', 'AI & ML', 'AI', 'Artificial intelligence and machine learning capability our team is equipped to bring to future products.', 'assets/icons/ai.svg', '#F97316', NULL),
('openai', 'OpenAI', 'AI', 'Leveraging GPT and other OpenAI models to build intelligent, conversational, and generative AI features.', 'assets/icons/openai.svg', '#10A37F', NULL),
('tensorflow', 'TensorFlow', 'AI', 'Google''s open-source machine learning framework for building and deploying ML models at scale.', 'assets/icons/tensorflow.svg', '#FF6F00', NULL);
GO

-- ============================================
-- Insert Solutions
-- ============================================
INSERT INTO [dbo].[Solutions] ([ExternalId], [Title], [Description], [Icon], [Color], [Features])
VALUES
(
    'marketplace',
    'Marketplace Platforms',
    'Live in SVAGS today: a two-sided marketplace connecting car owners with service centers, with secure booking and real-time updates.',
    'pi pi-shopping-cart',
    '#009688',
    '["Multi-vendor support","Payment integration","Real-time updates","Analytics dashboard"]'
),
(
    'mobile',
    'Mobile Applications',
    'Live in SVAGS today: native Android and iOS apps alongside the web platform, built from a shared engineering core.',
    'pi pi-mobile',
    '#8B5CF6',
    '["iOS & Android","Offline support","Push notifications","Biometric auth"]'
),
(
    'enterprise',
    'Enterprise Software',
    'Where we can help next: scalable applications for complex business workflows, team collaboration, and data-driven decision making.',
    'pi pi-building',
    '#6366F1',
    '["Role-based access","Workflow automation","ERP integration","Custom reporting"]'
),
(
    'cloud',
    'Cloud Solutions',
    'Where we can help next: cloud-native architecture on Azure, designed for scalability and cost-optimized infrastructure.',
    'pi pi-cloud',
    '#0078D4',
    '["Auto-scaling","Multi-region","Monitoring & alerting","Cost optimization"]'
),
(
    'ai',
    'AI Solutions',
    'Where we can help next: intelligent automation and AI-powered features that turn raw data into actionable insight.',
    'pi pi-sparkles',
    '#F59E0B',
    '["Predictive analytics","NLP processing","Computer vision","Recommendation engines"]'
),
(
    'custom',
    'Custom Software',
    'Bespoke software solutions tailored to your business requirements, built with the same standards we hold our own products to.',
    'pi pi-code',
    '#10B981',
    '["Requirements analysis","Agile development","Quality assurance","Ongoing support"]'
);
GO

-- ============================================
-- Insert Industries
-- ============================================
INSERT INTO [dbo].[Industries] ([ExternalId], [Name], [Description], [Icon], [Color], [UseCases])
VALUES
(
    'automotive',
    'Automotive',
    'Live today: SVAGS connects vehicle owners, service centers, and parts suppliers on one smart platform.',
    'pi pi-car',
    '#009688',
    '["Service booking","Fleet management","Parts marketplace","Diagnostics"]'
),
(
    'healthcare',
    'Healthcare',
    'Where we see opportunity next: digital health tools that improve patient outcomes and streamline clinical workflows.',
    'pi pi-heart',
    '#EF4444',
    '["Patient portals","Appointment scheduling","Medical records","Telemedicine"]'
),
(
    'education',
    'Education',
    'Where we see opportunity next: EdTech platforms that make quality education more accessible and measurable.',
    'pi pi-graduation-cap',
    '#6366F1',
    '["LMS platforms","Virtual classrooms","Assessment tools","Student analytics"]'
),
(
    'finance',
    'Finance',
    'Where we see opportunity next: fintech tooling for payments, lending, and compliance-driven workflows.',
    'pi pi-chart-line',
    '#10B981',
    '["Payment processing","Loan management","KYC/AML","Financial reporting"]'
),
(
    'retail',
    'Retail',
    'Where we see opportunity next: omnichannel retail technology unifying online and offline experiences.',
    'pi pi-shopping-bag',
    '#F59E0B',
    '["E-commerce","Inventory management","POS systems","Loyalty programs"]'
),
(
    'government',
    'Government',
    'Where we see opportunity next: citizen-centric digital services that improve public service delivery.',
    'pi pi-verified',
    '#8B5CF6',
    '["Citizen portals","Document management","Public services","Data analytics"]'
);
GO

-- ============================================
-- Insert Company Profile
-- ============================================
INSERT INTO [dbo].[CompanyProfiles] ([Name], [Founded], [Headquarters], [Mission], [Vision], [Description])
VALUES
(
    'SVAGS TECHNOLOGIES',
    '2026',
    'India',
    'To build innovative software products that simplify everyday life and empower businesses worldwide through technology.',
    'To become a globally recognized technology company that creates multiple impactful products across diverse industries.',
    'SVAGS TECHNOLOGIES is an Indian technology company on a mission to build world-class software products. We combine deep engineering expertise with a passion for design to create products that people love.'
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
    ('innovation', 'Innovation First', 'We challenge the status quo and embrace new ideas. Every product we build starts with asking ''what if we could do this better?''', 'pi pi-sparkles', '#009688'),
    ('security', 'Security by Design', 'Security is not an afterthought. We architect every system with security at its core, protecting our users and their data.', 'pi pi-shield', '#6366F1'),
    ('engineering', 'Engineering Excellence', 'We hold ourselves to the highest engineering standards. Clean code, robust architecture, and continuous improvement define us.', 'pi pi-code', '#8B5CF6'),
    ('scalability', 'Built to Scale', 'We design for tomorrow, not just today. Our systems are architected to handle millions of users without breaking a sweat.', 'pi pi-chart-bar', '#F59E0B'),
    ('customer', 'Customer First', 'Our customers are at the heart of everything we do. We listen, learn, and build products that genuinely solve real problems.', 'pi pi-heart', '#EF4444')
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
    ('June 16, 2026', 'Company Incorporated', 'SVAGS TECHNOLOGIES PRIVATE LIMITED was incorporated in India on June 16, 2026 with a vision to build world-class software products.'),
    ('August 17, 2026', 'SVAGS Launched', 'Our first product, SVAGS — a Smart Car Service Platform — launched on August 17, 2026 as a website and native Android and iOS app, connecting car owners with trusted service centers.')
) AS vals([year], [title], [description]);
GO

-- ============================================
-- Insert Careers Information
-- ============================================
INSERT INTO [dbo].[CareersInfos] ([Headline], [Subheadline])
VALUES
(
    'Build the Future With Us',
    'Join a team of passionate engineers, designers, and product thinkers who are building technology that matters.'
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
    ('pi pi-bolt', 'High Impact Work', 'Work on products used by thousands of people. Your code ships to production and makes a real difference.'),
    ('pi pi-users', 'Great Team', 'Work alongside talented, humble, and driven people who care deeply about craft and quality.'),
    ('pi pi-chart-line', 'Rapid Growth', 'We are growing fast. There is enormous opportunity to take ownership and grow your career quickly.'),
    ('pi pi-globe', 'Remote Friendly', 'We believe great work can happen anywhere. Flexible work arrangements for the right candidates.'),
    ('pi pi-book', 'Learning Budget', 'Dedicated budget for courses, conferences, books, and anything that helps you grow professionally.'),
    ('pi pi-heart', 'Health & Wellness', 'Comprehensive health coverage and wellness programs to keep you at your best.')
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
    (1, 'Apply', 'Submit your application with your resume and a brief note about why you want to join.'),
    (2, 'Screening', 'A 30-minute call with our team to learn about you and share more about the role.'),
    (3, 'Technical', 'A practical technical assessment relevant to the role you are applying for.'),
    (4, 'Interview', 'In-depth conversations with the team to assess culture fit and technical depth.'),
    (5, 'Offer', 'We move fast. If it is a great fit, you will receive an offer within days.')
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
    ('sde-angular', 'Senior Angular Developer', 'Engineering', 'Full-time', 'Remote / India', '3-6 years', 'Build world-class web applications using Angular, TypeScript, and modern frontend technologies.'),
    ('sde-dotnet', 'Senior .NET Developer', 'Engineering', 'Full-time', 'Remote / India', '3-6 years', 'Design and build scalable backend APIs and services using .NET, C#, and Azure.'),
    ('flutter-dev', 'Flutter Developer', 'Engineering', 'Full-time', 'Remote / India', '2-5 years', 'Create beautiful, performant cross-platform mobile applications using Flutter and Dart.'),
    ('product-designer', 'Product Designer', 'Design', 'Full-time', 'Remote / India', '3-5 years', 'Design intuitive, beautiful product experiences from concept to pixel-perfect implementation.')
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
    ('graduate', 'Graduate Program', 'A structured 12-month program for fresh graduates to learn, grow, and contribute to real products from day one.', 'pi pi-graduation-cap'),
    ('internship', 'Internship Program', '6-month internships for students who want to gain real-world experience building production software.', 'pi pi-star')
) AS vals([id], [title], [description], [icon]);
GO

-- ============================================
-- Insert News Articles
-- ============================================
INSERT INTO [dbo].[NewsArticles] ([ExternalId], [Title], [Excerpt], [Category], [Date], [ReadTime], [Featured], [Tags])
VALUES
(
    'svags-launch',
    'SVAGS Technologies Launches Its First Product: SVAGS Smart Car Service Platform',
    'SVAGS TECHNOLOGIES announces the launch of SVAGS, a smart car service platform available on web, Android, and iOS, connecting vehicle owners with trusted service centers.',
    'Product Launch',
    '2026-08-17',
    '3 min read',
    1,
    '["Product Launch","SVAGS","Automotive"]'
),
(
    'company-founded',
    'SVAGS TECHNOLOGIES Incorporated in India',
    'We are excited to announce the incorporation of SVAGS TECHNOLOGIES, an Indian technology company with a vision to build multiple world-class software products.',
    'Company Update',
    '2026-06-16',
    '2 min read',
    0,
    '["Company","Announcement"]'
);
GO

PRINT 'All seed data inserted successfully!';
GO
