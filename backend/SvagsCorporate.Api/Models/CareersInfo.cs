namespace SvagsCorporate.Api.Models;

public class CareersInfo
{
    public int Id { get; set; }
    public required string Headline { get; set; }
    public required string Subheadline { get; set; }

    public virtual ICollection<Benefit> Benefits { get; set; } = new List<Benefit>();
    public virtual ICollection<HiringStep> HiringProcess { get; set; } = new List<HiringStep>();
    public virtual ICollection<JobPosition> OpenPositions { get; set; } = new List<JobPosition>();
    public virtual ICollection<CareerProgram> Programs { get; set; } = new List<CareerProgram>();

    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

public class Benefit
{
    public int Id { get; set; }
    public int CareersInfoId { get; set; }
    public required string Icon { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }

    public virtual CareersInfo? CareersInfo { get; set; }
}

public class HiringStep
{
    public int Id { get; set; }
    public int CareersInfoId { get; set; }
    public int Step { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }

    public virtual CareersInfo? CareersInfo { get; set; }
}

public class JobPosition
{
    public int Id { get; set; }
    public int CareersInfoId { get; set; }
    public string? ExternalId { get; set; }
    public required string Title { get; set; }
    public required string Department { get; set; }
    public required string Type { get; set; } // Full-time, Part-time, Contract
    public required string Location { get; set; }
    public required string Experience { get; set; }
    public required string Description { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public virtual CareersInfo? CareersInfo { get; set; }
}

public class CareerProgram
{
    public int Id { get; set; }
    public int CareersInfoId { get; set; }
    public string? ExternalId { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }
    public required string Icon { get; set; }

    public virtual CareersInfo? CareersInfo { get; set; }
}
