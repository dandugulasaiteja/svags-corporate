namespace SvagsCorporate.Api.Models;

public class NewsArticle
{
    public int Id { get; set; }
    public string? ExternalId { get; set; }
    public required string Title { get; set; }
    public required string Excerpt { get; set; }
    public required string Category { get; set; }
    public required string Date { get; set; }
    public required string ReadTime { get; set; }
    public bool Featured { get; set; }
    public required List<string> Tags { get; set; } = new();
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
