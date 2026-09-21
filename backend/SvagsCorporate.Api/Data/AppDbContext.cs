using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using SvagsCorporate.Api.Models;

namespace SvagsCorporate.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    // Content tables
    public DbSet<Product> Products { get; set; } = null!;
    public DbSet<Technology> Technologies { get; set; } = null!;
    public DbSet<Solution> Solutions { get; set; } = null!;
    public DbSet<Industry> Industries { get; set; } = null!;
    public DbSet<NewsArticle> NewsArticles { get; set; } = null!;

    // Company tables
    public DbSet<CompanyProfile> CompanyProfiles { get; set; } = null!;
    public DbSet<CompanyValue> CompanyValues { get; set; } = null!;
    public DbSet<Milestone> Milestones { get; set; } = null!;

    // Careers tables
    public DbSet<CareersInfo> CareersInfos { get; set; } = null!;
    public DbSet<Benefit> Benefits { get; set; } = null!;
    public DbSet<HiringStep> HiringSteps { get; set; } = null!;
    public DbSet<JobPosition> JobPositions { get; set; } = null!;
    public DbSet<CareerProgram> CareerPrograms { get; set; } = null!;

    // Form submissions
    public DbSet<ContactSubmission> ContactSubmissions { get; set; } = null!;
    public DbSet<NewsletterSubscriber> NewsletterSubscribers { get; set; } = null!;
    public DbSet<JobApplication> JobApplications { get; set; } = null!;

    private static readonly ValueComparer<List<string>> StringListComparer = new(
        (a, b) => (a ?? new List<string>()).SequenceEqual(b ?? new List<string>()),
        v => v.Aggregate(0, (hash, s) => HashCode.Combine(hash, s.GetHashCode())),
        v => v.ToList());

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure value converters for List<string> properties using JSON serialization
        modelBuilder.Entity<Product>()
            .Property(p => p.Technologies)
            .HasConversion(
                v => System.Text.Json.JsonSerializer.Serialize(v),
                v => System.Text.Json.JsonSerializer.Deserialize<List<string>>(v) ?? new List<string>())
            .Metadata.SetValueComparer(StringListComparer);

        modelBuilder.Entity<Product>()
            .Property(p => p.Features)
            .HasConversion(
                v => System.Text.Json.JsonSerializer.Serialize(v),
                v => System.Text.Json.JsonSerializer.Deserialize<List<string>>(v) ?? new List<string>())
            .Metadata.SetValueComparer(StringListComparer);

        modelBuilder.Entity<Product>()
            .HasIndex(p => p.ExternalId)
            .IsUnique();

        // Solution
        modelBuilder.Entity<Solution>()
            .Property(s => s.Features)
            .HasConversion(
                v => System.Text.Json.JsonSerializer.Serialize(v),
                v => System.Text.Json.JsonSerializer.Deserialize<List<string>>(v) ?? new List<string>())
            .Metadata.SetValueComparer(StringListComparer);

        // Industry
        modelBuilder.Entity<Industry>()
            .Property(i => i.UseCases)
            .HasConversion(
                v => System.Text.Json.JsonSerializer.Serialize(v),
                v => System.Text.Json.JsonSerializer.Deserialize<List<string>>(v) ?? new List<string>())
            .Metadata.SetValueComparer(StringListComparer);

        // NewsArticle
        modelBuilder.Entity<NewsArticle>()
            .Property(n => n.Tags)
            .HasConversion(
                v => System.Text.Json.JsonSerializer.Serialize(v),
                v => System.Text.Json.JsonSerializer.Deserialize<List<string>>(v) ?? new List<string>())
            .Metadata.SetValueComparer(StringListComparer);

        // Company relationships
        modelBuilder.Entity<CompanyValue>()
            .HasOne(cv => cv.CompanyProfile)
            .WithMany(cp => cp.Values)
            .HasForeignKey(cv => cv.CompanyProfileId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<Milestone>()
            .HasOne(m => m.CompanyProfile)
            .WithMany(cp => cp.Milestones)
            .HasForeignKey(m => m.CompanyProfileId)
            .OnDelete(DeleteBehavior.Cascade);

        // Careers relationships
        modelBuilder.Entity<Benefit>()
            .HasOne(b => b.CareersInfo)
            .WithMany(ci => ci.Benefits)
            .HasForeignKey(b => b.CareersInfoId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<HiringStep>()
            .HasOne(h => h.CareersInfo)
            .WithMany(ci => ci.HiringProcess)
            .HasForeignKey(h => h.CareersInfoId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<JobPosition>()
            .HasOne(jp => jp.CareersInfo)
            .WithMany(ci => ci.OpenPositions)
            .HasForeignKey(jp => jp.CareersInfoId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<CareerProgram>()
            .HasOne(cp => cp.CareersInfo)
            .WithMany(ci => ci.Programs)
            .HasForeignKey(cp => cp.CareersInfoId)
            .OnDelete(DeleteBehavior.Cascade);

        // JobApplication
        modelBuilder.Entity<JobApplication>()
            .HasOne(ja => ja.JobPosition)
            .WithMany()
            .HasForeignKey(ja => ja.JobPositionId)
            .OnDelete(DeleteBehavior.SetNull);

        // Unique constraints
        modelBuilder.Entity<NewsletterSubscriber>()
            .HasIndex(ns => ns.Email)
            .IsUnique();
    }
}
