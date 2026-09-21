namespace SvagsCorporate.Api.Models;

public class NewsletterSubscriber
{
    public int Id { get; set; }
    public required string Email { get; set; }
    public bool IsActive { get; set; } = true;
    public string? IpAddress { get; set; }
    public DateTime SubscribedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UnsubscribedAt { get; set; }
}
