namespace SvagsCorporate.Api.Models;

public class Industry
{
    public int Id { get; set; }
    public string? ExternalId { get; set; }
    public required string Name { get; set; }
    public required string Description { get; set; }
    public required string Icon { get; set; }
    public required string Color { get; set; }
    public required List<string> UseCases { get; set; } = new();
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
