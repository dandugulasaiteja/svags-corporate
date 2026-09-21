namespace SvagsCorporate.Api.Models;

public class CompanyProfile
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public required string Founded { get; set; }
    public required string Headquarters { get; set; }
    public required string Mission { get; set; }
    public required string Vision { get; set; }
    public required string Description { get; set; }

    public virtual ICollection<CompanyValue> Values { get; set; } = new List<CompanyValue>();
    public virtual ICollection<Milestone> Milestones { get; set; } = new List<Milestone>();

    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

public class CompanyValue
{
    public int Id { get; set; }
    public int CompanyProfileId { get; set; }
    public string? ExternalId { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }
    public required string Icon { get; set; }
    public required string Color { get; set; }

    public virtual CompanyProfile? CompanyProfile { get; set; }
}

public class Milestone
{
    public int Id { get; set; }
    public int CompanyProfileId { get; set; }
    public required string Year { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }

    public virtual CompanyProfile? CompanyProfile { get; set; }
}
