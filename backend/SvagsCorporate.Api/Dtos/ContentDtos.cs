namespace SvagsCorporate.Api.Dtos;

// Product
public class ProductDto
{
    public string? Id { get; set; }
    public required string Name { get; set; }
    public required string Tagline { get; set; }
    public required string Description { get; set; }
    public required string Status { get; set; }
    public string? Url { get; set; }
    public required string Icon { get; set; }
    public required string Color { get; set; }
    public required List<string> Technologies { get; set; } = new();
    public required List<string> Features { get; set; } = new();
}

// Technology
public class TechnologyDto
{
    public string? Id { get; set; }
    public required string Name { get; set; }
    public required string Category { get; set; }
    public required string Description { get; set; }
    public required string Icon { get; set; }
    public required string Color { get; set; }
    public int? Proficiency { get; set; }
}

// Solution
public class SolutionDto
{
    public string? Id { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }
    public required string Icon { get; set; }
    public required string Color { get; set; }
    public required List<string> Features { get; set; } = new();
}

// Industry
public class IndustryDto
{
    public string? Id { get; set; }
    public required string Name { get; set; }
    public required string Description { get; set; }
    public required string Icon { get; set; }
    public required string Color { get; set; }
    public required List<string> UseCases { get; set; } = new();
}

// Company
public class CompanyDto
{
    public required string Name { get; set; }
    public required string Founded { get; set; }
    public required string Headquarters { get; set; }
    public required string Mission { get; set; }
    public required string Vision { get; set; }
    public required string Description { get; set; }
    public required List<CompanyValueDto> Values { get; set; } = new();
    public required List<MilestoneDto> Milestones { get; set; } = new();
}

public class CompanyValueDto
{
    public string? Id { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }
    public required string Icon { get; set; }
    public required string Color { get; set; }
}

public class MilestoneDto
{
    public required string Year { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }
}

// Careers
public class CareersDto
{
    public required string Headline { get; set; }
    public required string Subheadline { get; set; }
    public required List<BenefitDto> Benefits { get; set; } = new();
    public required List<HiringStepDto> HiringProcess { get; set; } = new();
    public required List<JobPositionDto> OpenPositions { get; set; } = new();
    public required List<CareerProgramDto> Programs { get; set; } = new();
}

public class BenefitDto
{
    public required string Icon { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }
}

public class HiringStepDto
{
    public int Step { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }
}

public class JobPositionDto
{
    public string? Id { get; set; }
    public required string Title { get; set; }
    public required string Department { get; set; }
    public required string Type { get; set; }
    public required string Location { get; set; }
    public required string Experience { get; set; }
    public required string Description { get; set; }
}

public class CareerProgramDto
{
    public string? Id { get; set; }
    public required string Title { get; set; }
    public required string Description { get; set; }
    public required string Icon { get; set; }
}

// News
public class NewsArticleDto
{
    public string? Id { get; set; }
    public required string Title { get; set; }
    public required string Excerpt { get; set; }
    public required string Category { get; set; }
    public required string Date { get; set; }
    public required string ReadTime { get; set; }
    public bool Featured { get; set; }
    public required List<string> Tags { get; set; } = new();
}
