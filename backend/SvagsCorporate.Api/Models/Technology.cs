namespace SvagsCorporate.Api.Models;

public class Technology
{
    public int Id { get; set; }
    public string? ExternalId { get; set; }
    public required string Name { get; set; }
    public required string Category { get; set; }
    public required string Description { get; set; }
    public required string Icon { get; set; }
    public required string Color { get; set; }
    public int? Proficiency { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
