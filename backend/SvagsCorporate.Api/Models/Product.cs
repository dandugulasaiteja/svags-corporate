namespace SvagsCorporate.Api.Models;

public class Product
{
    public int Id { get; set; }
    public string? ExternalId { get; set; } // svags, svags-bulk-messaging
    public required string Name { get; set; }
    public required string Tagline { get; set; }
    public required string Description { get; set; }
    public required string Status { get; set; } // live, coming-soon, beta
    public string? Url { get; set; }
    public required string Icon { get; set; } // pi pi-car
    public required string Color { get; set; } // hex color
    public required List<string> Technologies { get; set; } = new();
    public required List<string> Features { get; set; } = new();
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
