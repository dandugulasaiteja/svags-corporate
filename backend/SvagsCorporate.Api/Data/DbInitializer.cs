using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using SvagsCorporate.Api.Models;

namespace SvagsCorporate.Api.Data;

public class DbInitializer
{
    private readonly AppDbContext _context;
    private readonly ILogger<DbInitializer> _logger;
    private readonly string _seedDataPath;

    public DbInitializer(AppDbContext context, ILogger<DbInitializer> logger, string seedDataPath)
    {
        _context = context;
        _logger = logger;
        _seedDataPath = seedDataPath;
    }

    public async Task InitializeAsync()
    {
        try
        {
            // Only seed if database is empty
            if (await _context.Products.AsQueryable().AnyAsync())
            {
                _logger.LogInformation("Database already seeded");
                return;
            }

            _logger.LogInformation("Seeding database...");

            await SeedProductsAsync();
            await SeedTechnologiesAsync();
            await SeedSolutionsAsync();
            await SeedIndustriesAsync();
            await SeedCompanyAsync();
            await SeedCareersAsync();
            await SeedNewsAsync();

            await _context.SaveChangesAsync();
            _logger.LogInformation("Database seeding completed successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error seeding database");
            throw;
        }
    }

    private async Task SeedProductsAsync()
    {
        var json = await File.ReadAllTextAsync(Path.Combine(_seedDataPath, "products.json"));
        var data = JsonSerializer.Deserialize<JsonElement>(json);
        var products = data.GetProperty("products");

        foreach (var item in products.EnumerateArray())
        {
            var product = new Product
            {
                ExternalId = item.GetProperty("id").GetString(),
                Name = item.GetProperty("name").GetString() ?? "",
                Tagline = item.GetProperty("tagline").GetString() ?? "",
                Description = item.GetProperty("description").GetString() ?? "",
                Status = item.GetProperty("status").GetString() ?? "",
                Url = item.GetProperty("url").ValueKind != JsonValueKind.Null ? item.GetProperty("url").GetString() : null,
                Icon = item.GetProperty("icon").GetString() ?? "",
                Color = item.GetProperty("color").GetString() ?? "",
                Technologies = item.GetProperty("technologies").EnumerateArray().Select(t => t.GetString() ?? "").ToList(),
                Features = item.GetProperty("features").EnumerateArray().Select(f => f.GetString() ?? "").ToList(),
            };
            _context.Products.Add(product);
        }
    }

    private async Task SeedTechnologiesAsync()
    {
        var json = await File.ReadAllTextAsync(Path.Combine(_seedDataPath, "technologies.json"));
        var data = JsonSerializer.Deserialize<JsonElement>(json);
        var technologies = data.GetProperty("technologies");

        foreach (var item in technologies.EnumerateArray())
        {
            var tech = new Technology
            {
                ExternalId = item.GetProperty("id").GetString(),
                Name = item.GetProperty("name").GetString() ?? "",
                Category = item.GetProperty("category").GetString() ?? "",
                Description = item.GetProperty("description").GetString() ?? "",
                Icon = item.GetProperty("icon").GetString() ?? "",
                Color = item.GetProperty("color").GetString() ?? "",
                Proficiency = item.TryGetProperty("proficiency", out var prof) && prof.ValueKind != JsonValueKind.Null ? prof.GetInt32() : null,
            };
            _context.Technologies.Add(tech);
        }
    }

    private async Task SeedSolutionsAsync()
    {
        var json = await File.ReadAllTextAsync(Path.Combine(_seedDataPath, "solutions.json"));
        var data = JsonSerializer.Deserialize<JsonElement>(json);
        var solutions = data.GetProperty("solutions");

        foreach (var item in solutions.EnumerateArray())
        {
            var solution = new Solution
            {
                ExternalId = item.GetProperty("id").GetString(),
                Title = item.GetProperty("title").GetString() ?? "",
                Description = item.GetProperty("description").GetString() ?? "",
                Icon = item.GetProperty("icon").GetString() ?? "",
                Color = item.GetProperty("color").GetString() ?? "",
                Features = item.GetProperty("features").EnumerateArray().Select(f => f.GetString() ?? "").ToList(),
            };
            _context.Solutions.Add(solution);
        }
    }

    private async Task SeedIndustriesAsync()
    {
        var json = await File.ReadAllTextAsync(Path.Combine(_seedDataPath, "industries.json"));
        var data = JsonSerializer.Deserialize<JsonElement>(json);
        var industries = data.GetProperty("industries");

        foreach (var item in industries.EnumerateArray())
        {
            var industry = new Industry
            {
                ExternalId = item.GetProperty("id").GetString(),
                Name = item.GetProperty("name").GetString() ?? "",
                Description = item.GetProperty("description").GetString() ?? "",
                Icon = item.GetProperty("icon").GetString() ?? "",
                Color = item.GetProperty("color").GetString() ?? "",
                UseCases = item.GetProperty("useCases").EnumerateArray().Select(u => u.GetString() ?? "").ToList(),
            };
            _context.Industries.Add(industry);
        }
    }

    private async Task SeedCompanyAsync()
    {
        var json = await File.ReadAllTextAsync(Path.Combine(_seedDataPath, "about.json"));
        var data = JsonSerializer.Deserialize<JsonElement>(json);
        var companyData = data.GetProperty("company");

        var company = new CompanyProfile
        {
            Name = companyData.GetProperty("name").GetString() ?? "",
            Founded = companyData.GetProperty("founded").GetString() ?? "",
            Headquarters = companyData.GetProperty("headquarters").GetString() ?? "",
            Mission = companyData.GetProperty("mission").GetString() ?? "",
            Vision = companyData.GetProperty("vision").GetString() ?? "",
            Description = companyData.GetProperty("description").GetString() ?? "",
        };

        var values = companyData.GetProperty("values");
        foreach (var value in values.EnumerateArray())
        {
            company.Values.Add(new CompanyValue
            {
                ExternalId = value.GetProperty("id").GetString(),
                Title = value.GetProperty("title").GetString() ?? "",
                Description = value.GetProperty("description").GetString() ?? "",
                Icon = value.GetProperty("icon").GetString() ?? "",
                Color = value.GetProperty("color").GetString() ?? "",
            });
        }

        var milestones = companyData.GetProperty("milestones");
        foreach (var milestone in milestones.EnumerateArray())
        {
            company.Milestones.Add(new Milestone
            {
                Year = milestone.GetProperty("year").GetString() ?? "",
                Title = milestone.GetProperty("title").GetString() ?? "",
                Description = milestone.GetProperty("description").GetString() ?? "",
            });
        }

        _context.CompanyProfiles.Add(company);
    }

    private async Task SeedCareersAsync()
    {
        var json = await File.ReadAllTextAsync(Path.Combine(_seedDataPath, "careers.json"));
        var data = JsonSerializer.Deserialize<JsonElement>(json);
        var careersData = data.GetProperty("careers");

        var careers = new CareersInfo
        {
            Headline = careersData.GetProperty("headline").GetString() ?? "",
            Subheadline = careersData.GetProperty("subheadline").GetString() ?? "",
        };

        var benefits = careersData.GetProperty("benefits");
        foreach (var benefit in benefits.EnumerateArray())
        {
            careers.Benefits.Add(new Benefit
            {
                Icon = benefit.GetProperty("icon").GetString() ?? "",
                Title = benefit.GetProperty("title").GetString() ?? "",
                Description = benefit.GetProperty("description").GetString() ?? "",
            });
        }

        var hiringProcess = careersData.GetProperty("hiringProcess");
        foreach (var step in hiringProcess.EnumerateArray())
        {
            careers.HiringProcess.Add(new HiringStep
            {
                Step = step.GetProperty("step").GetInt32(),
                Title = step.GetProperty("title").GetString() ?? "",
                Description = step.GetProperty("description").GetString() ?? "",
            });
        }

        var positions = careersData.GetProperty("openPositions");
        foreach (var position in positions.EnumerateArray())
        {
            careers.OpenPositions.Add(new JobPosition
            {
                ExternalId = position.GetProperty("id").GetString(),
                Title = position.GetProperty("title").GetString() ?? "",
                Department = position.GetProperty("department").GetString() ?? "",
                Type = position.GetProperty("type").GetString() ?? "",
                Location = position.GetProperty("location").GetString() ?? "",
                Experience = position.GetProperty("experience").GetString() ?? "",
                Description = position.GetProperty("description").GetString() ?? "",
            });
        }

        var programs = careersData.GetProperty("programs");
        foreach (var program in programs.EnumerateArray())
        {
            careers.Programs.Add(new CareerProgram
            {
                ExternalId = program.GetProperty("id").GetString(),
                Title = program.GetProperty("title").GetString() ?? "",
                Description = program.GetProperty("description").GetString() ?? "",
                Icon = program.GetProperty("icon").GetString() ?? "",
            });
        }

        _context.CareersInfos.Add(careers);
    }

    private async Task SeedNewsAsync()
    {
        var json = await File.ReadAllTextAsync(Path.Combine(_seedDataPath, "news.json"));
        var data = JsonSerializer.Deserialize<JsonElement>(json);
        var newsArray = data.GetProperty("news");

        foreach (var item in newsArray.EnumerateArray())
        {
            var article = new NewsArticle
            {
                ExternalId = item.GetProperty("id").GetString(),
                Title = item.GetProperty("title").GetString() ?? "",
                Excerpt = item.GetProperty("excerpt").GetString() ?? "",
                Category = item.GetProperty("category").GetString() ?? "",
                Date = item.GetProperty("date").GetString() ?? "",
                ReadTime = item.GetProperty("readTime").GetString() ?? "",
                Featured = item.GetProperty("featured").GetBoolean(),
                Tags = item.GetProperty("tags").EnumerateArray().Select(t => t.GetString() ?? "").ToList(),
            };
            _context.NewsArticles.Add(article);
        }
    }
}
